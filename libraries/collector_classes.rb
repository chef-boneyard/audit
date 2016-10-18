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
    @node_name = ''

    def initialize(entity_uuid, run_id, node_name)
      @entity_uuid = entity_uuid
      @run_id = run_id
      @node_name = node_name
    end

    # Method used in order to send the inspec report to the data_collector server
    def send_report
      unless @entity_uuid && @run_id
        Chef::Log.warn "entity_uuid(#{@entity_uuid}) or run_id(#{@run_id}) can't be nil, not sending report..."
        return false
      end

      # get file contents where inspec results were saved
      result_path = File.expand_path("../../inspec_results.txt", __FILE__)
      file = File.open(result_path, "rb")
      content = file.read
      file.close

      # parse that string of contents into json
      json_report = enriched_report(JSON.parse(content))

      unless json_report
        Chef::Log.warn 'Something went wrong, report can\'t be nil'
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

    # ***************************************************************************************
    # TODO: We could likely simplify/remove alot of the extra logic we have here with a small
    # revamp of the visibility expected input.
    # ***************************************************************************************

    def enriched_report(content)
      return nil unless content.is_a?(Hash)
      final_report = {}
      total_duration = content['statistics']['duration']
      inspec_version = content['version']

      # strip the report to leave only the profiles
      final_report['profiles'] = content['profiles']

      # remove nil profiles if any
      final_report['profiles'].select! { |p| p }

      # add some additional fields to ease report parsing
      final_report['event_type'] = 'inspec'
      final_report['event_action'] = 'exec'
      final_report['compliance_summary'] = count_controls(final_report['profiles'])
      final_report['compliance_summary']['status'] = compliance_status(final_report['compliance_summary'])
      final_report['compliance_summary']['node_name'] = @node_name
      final_report['compliance_summary']['end_time'] = DateTime.now.iso8601
      final_report['compliance_summary']['duration'] = total_duration
      final_report['compliance_summary']['inspec_version'] = inspec_version
      final_report['entity_uuid'] = @entity_uuid
      final_report['run_id'] = @run_id
      Chef::Log.info "Compliance Summary #{final_report['compliance_summary']}"
      final_report.to_json
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
  end
end