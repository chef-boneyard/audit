# encoding: utf-8
require 'json'
require_relative '../helper'

module Reporter
  #
  # Used to send inspec reports to a Chef Compliance server
  #
  class ChefCompliance
    include ReportHelpers

    def initialize(opts)
      @node_info = opts[:node_info]
      @url = opts[:url]
      @raise_if_unreachable = opts[:raise_if_unreachable]
      @compliance_profiles = opts[:compliance_profiles]
      @insecure = opts[:insecure]
      @token = opts[:token]
    end

    def send_report(report)
      Chef::Log.info "Report to Chef Compliance: #{@url} with #{@token}"
      req = Net::HTTP::Post.new(@url, { 'Authorization' => "Bearer #{@token}" })

      json_report = enriched_report(report)
      req.body = json_report

      # TODO: use secure option
      uri = URI(@url)
      opts = {
        use_ssl: uri.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
      }
      Net::HTTP.start(uri.host, uri.port, opts) do |http|
        with_http_rescue do
          http.request(req)
        end
      end
      return true
    rescue => e
      Chef::Log.error "send_report: POST to #{@url} returned: #{e.message}"
      return false
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
end
