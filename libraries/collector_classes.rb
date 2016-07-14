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
    @node_name = nil
    @blob = []

    def initialize(entity_uuid, run_id, node_name, blob)
      @entity_uuid = entity_uuid
      @run_id = run_id
      @node_name = node_name
      @blob = blob
    end
    def send_report
      send_inspec_report
    end

    private

    # Transforms this hash:
    # {'a1'=>{'a2'=>'a3'},'b1'=>{'b2'=>'b3'}}
    # in this array:
    # [{'id'=>'a1','a2'=>'a3'},{'id'=>'b1','b2'=>'b3'}]
    def hash_to_array(hash)
      return unless hash.is_a?(Hash);
      hash.each { |k,v| v['id'] = k }
      hash.values
    end

    # A control can have multiple tests. Returns 'passed' unless any
    # of the results has a status different than 'passed'
    def control_status(results)
      return unless results.is_a?(Array)
      results.each do |result|
        return result['status'] unless result['status'] == 'passed'
      end
      return 'passed'
    end

    # Returns a complince status string based on the passed/failed/skipped controls
    def compliance_status(counts)
      if counts['failed'] > 0
        return 'uncompliant'
      elsif counts['total'] == counts['skipped']
        return 'skipped'
      else
        return 'compliant'
      end
    end

    # Returns a string with the control criticality based on the impact value
    def impact_to_s(impact)
      if impact < 0.4
        return 'minor';
      elsif impact < 0.7
        return 'major';
      else
        return 'critical';
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
        'successful' => 0,
        'skipped' => 0,
        'failed' => 0,
        'minor' => 0,
        'major' => 0,
        'critical' => 0
      }
      return count unless profiles.is_a?(Array)
      profiles.each do |profile|
        if profile && profile['controls'].is_a?(Array)
          profile['controls'].each do |control|
            count['total'] += 1;
            # ensure all impacts are float
            control['impact'] = control['impact'].to_f
            case control_status(control['results'])
            when "passed"
              count['successful'] += 1;
            when "skipped"
              count['skipped'] += 1;
            when "failed"
              count['failed'] += 1;
              criticality = impact_to_s(control['impact'])
              count[criticality] += 1 unless criticality.nil?
            end
          end
        end
      end
      count
    end

    # Return a json string containing the inspec report to be sent to the data_collector
    def enrich_report(reports)
      final_report = {}
      # strip the report to leave only the profiles
      final_report['profiles'] = reports.map do |name, content|
        content['profiles'].values.first if content.is_a?(Hash) &&
                                            content['profiles'].is_a?(Hash) &&
                                            content['profiles'].values.is_a?(Array)
      end

      # remove nil profiles if any
      final_report['profiles'].select!{ |p| p }

      # using hash_to_array to remove non-static keys
      final_report['profiles'].each do |profile|
        profile['controls'] = hash_to_array(profile['controls'])
        profile['groups'] = hash_to_array(profile['groups'])
      end

      # add some additional fields to ease report parsing
      final_report['event_type'] = 'inspec'
      final_report['event_action'] = 'exec'
      final_report['compliance_summary'] = {}
      final_report['compliance_summary']['controls_count'] = count_controls(final_report['profiles'])
      final_report['compliance_summary']['compliance'] = compliance_status(final_report['compliance_summary']['controls_count'])
      final_report['compliance_summary']['end_time'] = Time.now.utc.iso8601
      final_report['compliance_summary']['name'] = @node_name
      final_report['entity_uuid'] = @entity_uuid
      final_report['run_id'] = @run_id

      ### might be needed unless we use entity_uuid in 95-node-state-filter.conf
      #    final_report['organization_name'] = "chef_solo"
      #    final_report['source_fqdn'] = "localhost"
      #    final_report['node_name'] = "chef-client.solo"

      Chef::Log.info "Compliance Controls Count #{final_report['compliance_summary']['controls_count']}"
      final_report.to_json
    end

    # Method used in order to send the inspec report to the data_collector server
    def send_inspec_report
      if (defined?(Chef) &&
          defined?(Chef::Config) &&
          Chef::Config[:data_collector] &&
          Chef::Config[:data_collector][:token] &&
          Chef::Config[:data_collector][:server_url])

        dc = Chef::Config[:data_collector]
        json_report = enrich_report(@blob[:reports])
        headers = { 'Content-Type' => 'application/json' }
        unless dc[:token].nil?
          headers['x-data-collector-token'] = dc[:token]
          headers['x-data-collector-auth'] = 'version=1.0'
        end

        begin
          Chef::Log.debug("send_inspec_report: POSTing the following message to #{dc[:server_url]}: #{json_report}")
          http = Chef::HTTP.new(dc[:server_url])
          http.post(nil, json_report, headers)
          true
        rescue => e
          Chef::Log.error "send_inspec_report: POSTing to #{dc[:server_url]} returned: #{e.message}"
          false
        end
      else
        Chef::Log.warn 'data_collector.token and data_collector.server_url must be defined in client.rb!'
        false
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
      Chef::Log.info "Report to: #{@url}"
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

    def initialize(url, blob, token)
      @url = url
      @blob = blob
      @token = token
    end
    def send_report
      req = Net::HTTP::Post.new(@url, { 'Authorization' => "Bearer #{@token}" })
      req.body = blob.to_json
      Chef::Log.info "Report to: #{@url}"

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
