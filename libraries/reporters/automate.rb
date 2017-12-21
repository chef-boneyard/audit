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
      @roles = opts[:node_info][:roles]
      @recipes = opts[:node_info][:recipes]
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
      report_size = json_report.bytesize
      if report_size > 5*1024*1024
        Chef::Log.warn "Compliance report size is #{(report_size / (1024*1024.0)).round(2)} MB."
      end

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
          Chef::Log.info "Report to Chef Automate: #{@url}"
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

    # ***************************************************************************************
    # TODO: We could likely simplify/remove alot of the extra logic we have here with a small
    # revamp of the Automate expected input.
    # ***************************************************************************************

    def enriched_report(final_report)
      return nil unless final_report.is_a?(Hash)

      # Remove nil profiles if any
      final_report[:profiles].select! { |p| p }

      # Label this content as an inspec_report
      final_report[:type] = 'inspec_report'

      # Ensure controls are never stored or shipped, since this was an accidential
      # addition in InSpec and will be remove in the next inspec major release
      final_report.delete(:controls)
      final_report[:node_name]   = @node_name
      final_report[:end_time]    = Time.now.utc.strftime('%FT%TZ')
      final_report[:node_uuid]   = @entity_uuid
      final_report[:environment] = @environment
      final_report[:roles]       = @roles
      final_report[:recipes]     = @recipes
      final_report[:report_uuid] = @run_id
      final_report
    end
  end
end
