# encoding: utf-8
require 'json'
require_relative 'helper'

class Collector
  #
  # Used to send inspec reports to Chef Visibility via the data_collector service
  #
  class ChefVisibility
    include ReportHelpers

    @entity_uuid = nil
    @run_id = nil
    @node_name = ''
    @report = ''

    def initialize(entity_uuid, run_id, node_info, insecure, report)
      @entity_uuid = entity_uuid
      @run_id = run_id
      @node_name = node_info[:node]
      @insecure = insecure
      @report = report
    end

    # Method used in order to send the inspec report to the data_collector server
    def send_report
      unless @entity_uuid && @run_id
        Chef::Log.warn "entity_uuid(#{@entity_uuid}) or run_id(#{@run_id}) can't be nil, not sending report..."
        return false
      end

      content = @report
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

        # Enable OpenSSL::SSL::VERIFY_NONE via `node['audit']['insecure']`
        # See https://github.com/chef/chef/blob/master/lib/chef/http/ssl_policies.rb#L54
        if @insecure
          Chef::Config[:verify_api_cert] = false
          Chef::Config[:ssl_verify_mode] = :verify_none
        end

        begin
          Chef::Log.warn "Report to Chef Visibility: #{dc[:server_url]}"
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

    # Some document stores like ElasticSearch don't like values that change type
    # This function converts all profile attribute defaults to string and
    # adds a 'type' key to store the original type
    def typed_attributes(profiles)
      return profiles unless profiles.class == Array && !profiles.empty?
      profiles.each { |profile|
        next unless profile['attributes'].class == Array && !profile['attributes'].empty?
        profile['attributes'].map { |attrib|
          case attrib['options']['default'].class.to_s
          when 'String'
            attrib['options']['type'] = 'string'
          when 'FalseClass'
            attrib['options']['type'] = 'boolean'
            attrib['options']['default'] = attrib['options']['default'].to_s
          when 'Fixnum'
            attrib['options']['type'] = 'int'
            attrib['options']['default'] = attrib['options']['default'].to_s
          when 'Float'
            attrib['options']['type'] = 'float'
            attrib['options']['default'] = attrib['options']['default'].to_s
          else
            Chef::Log.warn "enriched_report: unsupported data type(#{attrib['options']['default'].class}) for attribute #{attrib['options']['name']}"
            attrib['options']['type'] = 'unknown'
          end
        }
      }
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

      # set types for profile attributes
      final_report['profiles'] = typed_attributes(final_report['profiles'])

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
  end

  #
  # Used to send inspec reports to a Chef Compliance server
  #
  class ChefCompliance
    include ReportHelpers

    @url = nil
    @node_info = {}
    @report = ''

    def initialize(_url, node_info, raise_if_unreachable, compliance_profiles, report)
      @node_info = node_info
      @config = Compliance::Configuration.new
      Chef::Log.warn "Report to Chef Compliance: #{@config['user']}"
      Chef::Log.warn "#{@config['server']}/owners/#{@config['user']}/inspec"
      @url = URI("#{@config['server']}/owners/#{@config['user']}/inspec")
      @token = @config['token']
      @raise_if_unreachable = raise_if_unreachable
      @compliance_profiles = compliance_profiles
      @report = report
    end

    def send_report
      Chef::Log.info "Report to Chef Compliance: #{@token}"
      req = Net::HTTP::Post.new(@url, { 'Authorization' => "Bearer #{@token}" })

      content = @report
      json_report = enriched_report(JSON.parse(content))
      req.body = json_report

      Chef::Log.info "Report to Chef Compliance: #{@url}"

      # TODO: use secure option
      opts = { use_ssl: @url.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
      }
      Net::HTTP.start(@url.host, @url.port, opts) do |http|
        with_http_rescue do
          http.request(req)
        end
      end
    end

    # TODO: add to docs that all profiles used in Chef Compliance, need to
    # be uploaded to Chef Compliance first
    def enriched_report(report)
      blob = @node_info.dup

      # extract profile names
      profiles = report['controls'].collect { |control| control['profile_id'] }.uniq

      # build report for chef compliance, it includes node data
      blob[:reports] = {}
      blob[:profiles] = {}
      Chef::Log.info "Control Profile: #{profiles}"
      profiles.each { |profile|
        Chef::Log.info "Control Profile: #{profile}"
        Chef::Log.info "Compliance Profiles: #{@compliance_profiles}"
        namespace = @compliance_profiles.select { |entry| entry[:profile_id] == profile }
        unless namespace.nil? && namespace.empty?
          Chef::Log.debug "Namespace for #{profile} is #{namespace[0][:owner]}"
          blob[:profiles][profile] = namespace[0][:owner]
          blob[:reports][profile] = report.dup
          # filter controls by profile_id
          blob[:reports][profile]['controls'] = blob[:reports][profile]['controls'].select { |control| control['profile_id'] == profile }
        else
          Chef::Log.warn "Could not determine compliance namespace for #{profile}"
        end
      }

      blob.to_json
    end
  end

  #
  # Used to send inspec reports to a Chef Compliance server via Chef Server
  #
  class ChefServer < ChefCompliance
    @url = nil

    def initialize(url, node_info, raise_if_unreachable, compliance_profiles, report)
      @url = url
      @node_info = node_info
      @raise_if_unreachable = raise_if_unreachable
      @compliance_profiles = compliance_profiles
      @report = report
    end

    def send_report
      content = @report
      json_report = enriched_report(JSON.parse(content))

      # TODO: only disable if insecure option is set
      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none

      Chef::Log.info "Report to Chef Server: #{@url}"
      rest = Chef::ServerAPI.new(@url, Chef::Config)
      with_http_rescue do
        rest.post(@url, JSON.parse(json_report))
      end
    end
  end

  #
  # Used to send inspec reports to Chef Visibility server via Chef Server
  #
  class ChefServerVisibility < ChefVisibility
    def send_report(url)
      content = @report
      json_report = enriched_report(JSON.parse(content))

      if @insecure
        Chef::Config[:verify_api_cert] = false
        Chef::Config[:ssl_verify_mode] = :verify_none
      end

      Chef::Log.info "Report to Visibility via Chef Server: #{url}"
      rest = Chef::ServerAPI.new(url, Chef::Config)
      with_http_rescue do
        rest.post(url, JSON.parse(json_report))
      end
    end
  end

  #
  # Used to write report to file on disk
  #
  class JsonFile
    include ReportHelpers

    @report = ''

    def initialize(report, timestamp)
      @report = report
      @timestamp = timestamp
    end

    def send_report
      Chef::Log.warn 'Writing report to file.'
      write_to_file(@report, @timestamp)
    end

    def write_to_file(report, timestamp)
      filename = 'inspec' << '-' << timestamp << '.json'
      path = File.expand_path("../../#{filename}", __FILE__)
      Chef::Log.warn "Filename is #{path}"
      json_file = File.new(path, 'w')
      json_file.puts(report)
      json_file.close
    end
  end
end
