# encoding: utf-8
require 'json'
require_relative 'helper'

class Collector
  #
  # Used to send inspec reports to Chef Visibility via the data_collector service
  #
  class ChefVisibility
    @entity_uuid = nil
    @run_id = nil
    @blob = []

    def initialize(entity_uuid, run_id, blob)
      @entity_uuid = entity_uuid
      @run_id = run_id
      @blob = blob
    end

    # Transforms this hash:
    # {'a1'=>{'a2'=>'a3'},'b1'=>{'b2'=>'b3'}}
    # in this array:
    # [{'id'=>'a1','a2'=>'a3'},{'id'=>'b1','b2'=>'b3'}]
    def hash_to_array(hash)
      return unless hash.is_a?(Hash)
      hash.each { |k, v| v['id'] = k }
      hash.values
    end

    # A control can have multiple tests. Returns 'passed' unless any
    # of the results has a status different than 'passed'
    def control_status(results)
      return unless results.is_a?(Array)
      status = 'passed'
      results.each do |result|
        return 'failed' if result['status'] == 'failed'
        status = 'skipped' if result['status'] == 'skipped'
      end
      status
    end

    # Returns a complince status string based on the passed/failed/skipped controls
    def compliance_status(counts)
      return 'unknown' unless counts.is_a?(Hash) &&
                              counts['failed'].is_a?(Hash) &&
                              counts['skipped'].is_a?(Hash)
      if counts['failed']['total'] > 0
        'failed'
      elsif counts['total'] == counts['skipped']['total']
        'skipped'
      else
        'passed'
      end
    end

    # Returns a string with the control criticality based on the impact value
    def impact_to_s(impact)
      if impact < 0.4
        'minor'
      elsif impact < 0.7
        'major'
      else
        'critical'
      end
    end

    # Returns a hash with the counted controls based on their status and criticality
    # total: count for all controls in the report, e.g. 100
    # successful: count for all controls that executed successfully, e.g. 40
    # skipped: count for all skipped controls, e.g. 10
    # failed: count for all failed controls, e.g. 50
    # minor, major, critical: split the failed count in 3 buckets based on the criticality,
    #  e.g. minor: 10, major: 15, critical: 25
    def count_controls(profiles)
      count = {
        'total' => 0,
        'passed' => {
          'total' => 0,
        },
        'skipped' => {
          'total' => 0,
        },
        'failed' => {
          'total' => 0,
          'minor' => 0,
          'major' => 0,
          'critical' => 0,
        },
      }
      return count unless profiles.is_a?(Array)

      profiles.each do |profile|
        next unless profile && profile['controls'].is_a?(Array)
        profile['controls'].each do |control|
          count['total'] += 1
          # ensure all impacts are float
          control['impact'] = control['impact'].to_f
          case control_status(control['results'])
          when 'passed'
            count['passed']['total'] += 1
          when 'skipped'
            count['skipped']['total'] += 1
          when 'failed'
            count['failed']['total'] += 1
            criticality = impact_to_s(control['impact'])
            count['failed'][criticality] += 1 unless criticality.nil?
          end
        end
      end
      count
    end

    # Return a json string containing the inspec report to be sent to the data_collector
    def enriched_report
      return nil unless @blob.is_a?(Hash) && @blob[:reports].is_a?(Hash)
      final_report = {}
      node_name = @blob[:node] # ~FC001, ~FC019, ~FC039
      total_duration = 0
      inspec_version = 'unknown'
      # strip the report to leave only the profiles
      final_report['profiles'] = @blob[:reports].map do |_name, content|
        next unless content.is_a?(Hash) &&
                    content['profiles'].is_a?(Hash) &&
                    content['profiles'].values.is_a?(Array)
        inspec_version = content['version']
        total_duration += content['summary']['duration'] if content['summary'].is_a?(Hash)
        content['profiles'].values.first
      end

      # remove nil profiles if any
      final_report['profiles'].select! { |p| p }

      # using hash_to_array to remove non-static keys
      final_report['profiles'].each do |profile|
        profile['controls'] = hash_to_array(profile['controls'])
        profile['groups'] = hash_to_array(profile['groups'])
      end

      # add some additional fields to ease report parsing
      final_report['event_type'] = 'inspec'
      final_report['event_action'] = 'exec'
      final_report['compliance_summary'] = count_controls(final_report['profiles'])
      final_report['compliance_summary']['status'] = compliance_status(final_report['compliance_summary'])
      final_report['compliance_summary']['node_name'] = node_name
      final_report['compliance_summary']['end_time'] = DateTime.now.iso8601
      final_report['compliance_summary']['duration'] = total_duration
      final_report['compliance_summary']['inspec_version'] = inspec_version
      final_report['entity_uuid'] = @entity_uuid
      final_report['run_id'] = @run_id
      Chef::Log.info "Compliance Summary #{final_report['compliance_summary']}"
      final_report.to_json
    end

    # Method used in order to send the inspec report to the data_collector server
    def send_report
      unless @entity_uuid && @run_id
        Chef::Log.warn "entity_uuid(#{@entity_uuid}) or run_id(#{@run_id}) can't be nil, not sending report..."
        return false
      end
      json_report = enriched_report
      unless json_report
        Chef::Log.warn 'Something went wrong, enriched_report can\'t be nil'
        return false
      end
      if defined?(Chef) &&
         defined?(Chef::Config) &&
         Chef::Config[:data_collector] &&
         Chef::Config[:data_collector][:token] &&
         Chef::Config[:data_collector][:server_url]

        dc = Chef::Config[:data_collector]
        headers = { 'Content-Type' => 'application/json' }
        unless dc[:token].nil?
          headers['x-data-collector-token'] = dc[:token]
          headers['x-data-collector-auth'] = 'version=1.0'
        end

        begin
          Chef::Log.info "Report to Chef Visibility: #{dc[:server_url]}"
          Chef::Log.debug("POSTing the following message to #{dc[:server_url]}: #{json_report}")
          http = Chef::HTTP.new(dc[:server_url])
          http.post(nil, json_report, headers)
          return true
        rescue => e
          Chef::Log.error "send_inspec_report: POSTing to #{dc[:server_url]} returned: #{e.message}"
          return false
        end
      else
        Chef::Log.warn 'data_collector.token and data_collector.server_url must be defined in client.rb!'
        return false
      end
    end
  end

  #
  # Used to send inspec reports to a Chef Complinace server via Chef Server
  #
  class ChefServer
    include ComplianceHelpers

    @url = nil
    @blob = nil

    def initialize(url, blob)
      @url = url
      @blob = blob
    end

    def send_report
      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none
      Chef::Log.info "Report to Chef Server: #{@url}"
      rest = Chef::ServerAPI.new(@url, Chef::Config)
      with_http_rescue do
        rest.post(@url, @blob)
      end
    end
  end

  #
  # Used to send inspec reports to a Chef Complinace server
  #
  class ChefCompliance
    include ComplianceHelpers

    @url = nil
    @blob = nil

    def initialize(url, blob, token, raise_if_unreachable)
      @url = url
      @blob = blob
      @token = token
      @raise_if_unreachable = raise_if_unreachable
    end

    def send_report
      req = Net::HTTP::Post.new(@url, { 'Authorization' => "Bearer #{@token}" })
      req.body = @blob.to_json
      Chef::Log.info "Report to Chef Compliance: #{@url}"

      opts = { use_ssl: @url.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_NONE, # FIXME
      }
      Net::HTTP.start(@url.host, @url.port, opts) do |http|
        with_http_rescue do
          http.request(req)
        end
      end
    end
  end
end
