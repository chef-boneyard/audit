# encoding: utf-8
require 'json'
require_relative '../helper'
require_relative './automate'

module Reporter
  #
  # Used to send inspec reports to Chef Automate server via Chef Server
  #
  class ChefServerAutomate < ChefAutomate
    def initialize(opts)
      @entity_uuid = opts[:entity_uuid]
      @run_id = opts[:run_id]
      @node_name = opts[:node_info][:node]
      @insecure = opts[:insecure]
      @environment = opts[:node_info][:environment]
      @roles = opts[:node_info][:roles]
      @recipes = opts[:node_info][:recipes]
      @url = opts[:url]
    end

    def send_report(report)
      automate_report = enriched_report(report)
      report_size = automate_report.to_json.bytesize
      if report_size > 900 * 1024
        Chef::Log.warn "Compliance report size is #{(report_size / (1024 * 1024.0)).round(2)} MB."
      end

      if @insecure
        Chef::Config[:verify_api_cert] = false
        Chef::Config[:ssl_verify_mode] = :verify_none
      end

      Chef::Log.info "Report to Chef Automate via Chef Server: #{@url}"
      rest = Chef::ServerAPI.new(@url, Chef::Config)
      with_http_rescue do
        rest.post(@url, automate_report)
        return true
      end
      false
    end
  end
end
