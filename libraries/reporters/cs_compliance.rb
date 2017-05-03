# encoding: utf-8
require 'json'
require_relative '../helper'
require_relative './compliance'

module Reporter
  #
  # Used to send inspec reports to a Chef Compliance server via Chef Server
  #
  class ChefServerCompliance < ChefCompliance
    def send_report(report)
      min_report = transform(report)
      cc_report = enriched_report(min_report, @source_location)

      # TODO: only disable if insecure option is set
      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none

      Chef::Log.info "Report to Chef Compliance via Chef Server: #{@url}"
      rest = Chef::ServerAPI.new(@url, Chef::Config)
      with_http_rescue do
        rest.post(@url, cc_report)
        return true
      end
      false
    end
  end
end
