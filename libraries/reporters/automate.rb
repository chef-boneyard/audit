# encoding: utf-8
require 'json'
require_relative '../helper'

module Reporter
  #
  # Used to send inspec reports to Chef Automate via the data_collector service
  #
  class ChefAutomate
    include ReportHelpers

    def initialize(opts)
      @entity_uuid = opts[:entity_uuid]
      @run_id = opts[:run_id]
      @node_name = opts[:node_info][:node]
      @environment = opts[:node_info][:environment]
      @insecure = opts[:insecure]

      if defined?(Chef) &&
         defined?(Chef::Config) &&
         Chef::Config[:data_collector] &&
         Chef::Config[:data_collector][:token] &&
         Chef::Config[:data_collector][:server_url]

        dc = Chef::Config[:data_collector]
        @url = dc[:server_url]
        @token = dc[:token]
      end
    end

    # Method used in order to send the inspec report to the data_collector server
    def send_report(report)
      unless @entity_uuid && @run_id
        Chef::Log.error "entity_uuid(#{@entity_uuid}) or run_id(#{@run_id}) can't be nil, not sending report to Chef Automate"
        return false
      end

      json_report = enriched_report(report).to_json

      unless json_report
        Chef::Log.warn 'Something went wrong, report can\'t be nil'
        return false
      end

      if defined?(Chef) &&
         defined?(Chef::Config)

        headers = { 'Content-Type' => 'application/json' }
        unless @token.nil?
          headers['x-data-collector-token'] = @token
          headers['x-data-collector-auth'] = 'version=1.0'
        end

        # Enable OpenSSL::SSL::VERIFY_NONE via `node['audit']['insecure']`
        # See https://github.com/chef/chef/blob/master/lib/chef/http/ssl_policies.rb#L54
        if @insecure
          Chef::Config[:verify_api_cert] = false
          Chef::Config[:ssl_verify_mode] = :verify_none
        end

        begin
          Chef::Log.warn "Report to Chef Automate: #{@url}"
          Chef::Log.debug "Audit Report: #{json_report}"
          http = Chef::HTTP.new(@url)
          http.post(nil, json_report, headers)
          return true
        rescue => e
          Chef::Log.error "send_report: POST to #{@url} returned: #{e.message}"
          return false
        end
      else
        Chef::Log.warn 'data_collector.token and data_collector.server_url must be defined in client.rb!'
        Chef::Log.warn 'Further information: https://github.com/chef-cookbooks/audit#direct-reporting-to-chef-automate'
        return false
      end
    end

    # Some document stores like ElasticSearch don't like values that change type
    # This function converts all profile attribute defaults to string and
    # adds a :type key to store the original type
    def typed_attributes(profiles)
      return profiles unless profiles.class == Array && !profiles.empty?
      profiles.each { |profile|
        next unless profile[:attributes].class == Array && !profile[:attributes].empty?
        profile[:attributes].map { |attrib|
          case attrib[:options][:default].class.to_s
          when 'String'
            attrib[:options][:type] = 'string'
          when 'FalseClass'
            attrib[:options][:type] = 'boolean'
            attrib[:options][:default] = attrib[:options][:default].to_s
          when 'Fixnum'
            attrib[:options][:type] = 'int'
            attrib[:options][:default] = attrib[:options][:default].to_s
          when 'Float'
            attrib[:options][:type] = 'float'
            attrib[:options][:default] = attrib[:options][:default].to_s
          else
            Chef::Log.warn "enriched_report: unsupported data type(#{attrib[:options][:default].class}) for attribute #{attrib[:options]['name']}"
            attrib[:options][:type] = 'unknown'
          end
        }
      }
    end

    # ***************************************************************************************
    # TODO: We could likely simplify/remove alot of the extra logic we have here with a small
    # revamp of the Automate expected input.
    # ***************************************************************************************

    def enriched_report(final_report)
      return nil unless final_report.is_a?(Hash)

      # Remove nil profiles if any
      final_report[:profiles].select! { |p| p }

      # Set types for profile attributes
      final_report[:profiles] = typed_attributes(final_report[:profiles])

      # Label this content as an inspec_report
      final_report[:type] = 'inspec_report'

      # Ensure controls are never stored or shipped, since this was an accidential
      # addition in InSpec and will be remove in the next inspec major release
      final_report.delete(:controls)
      final_report[:node_name]   = @node_name
      final_report[:end_time]    = DateTime.now.iso8601
      final_report[:node_uuid]   = @entity_uuid
      final_report[:environment] = @environment
      final_report[:report_uuid] = @run_id
      final_report
    end
  end
end
