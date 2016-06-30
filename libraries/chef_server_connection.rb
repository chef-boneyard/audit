# encoding: utf-8

require 'uri'

module Audit
  class ChefServerConnection
    attr_accessor :server, :org
    def initialize(server, org)
      @server = server
      @org = org
      Chef::Log.debug "Creating chef server connection for server #{@server} and org #{@org}"
    end

    def fetch(profile)
      reqpath ="organizations/#{org}/owners/#{profile.owner}/compliance/#{profile.name}/tar"
      url = construct_url(server + '/compliance/', reqpath)
      Chef::Log.info "Load profile from: #{url}"
      Chef::Config[:verify_api_cert] = false # FIXME
      Chef::Config[:ssl_verify_mode] = :verify_none # FIXME
      rest = Chef::ServerAPI.new(url, Chef::Config)
      tf = ::Audit::HttpProcessor.with_http_rescue do
        Chef::Log.debug "Requesting profile from #{url}"
        rest.binmode_streaming_request(url)
      end
      tf
    end

    def construct_url(server, path)
      path.sub!(%r{^/}, '') # sanitize input
      server = URI(server)
      server.path = server.path + path if path
      server
    end

    def report(report_results)
      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none

      url = construct_url(server + '/compliance/', ::File.join('organizations', org, 'inspec'))
      Chef::Log.info "Report to: #{url}"

      rest = Chef::ServerAPI.new(url, Chef::Config)
      ::Audit::HttpProcessor.with_http_rescue do
        Chef::Log.debug "Posting to #{url} results: #{report_results}"
        rest.post(url, report_results)
      end
    end
  end
end
