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
      @insecure = opts[:insecure]
      @token = opts[:token]
      @source_location = opts[:source_location]
    end

    def send_report(report)
      Chef::Log.info "Report to Chef Compliance: #{@url} with #{@token}"
      req = Net::HTTP::Post.new(@url, { 'Authorization' => "Bearer #{@token}" })

      min_report = transform(report)
      json_report = enriched_report(min_report, @source_location)
      req.body = json_report.to_json

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
    def enriched_report(report, source_location)
      compliance_profiles = cc_profile_index(source_location)
      blob = @node_info.dup

      # extract profile names
      profiles = report[:controls].collect { |control| control[:profile_id] }.uniq

      # build report for chef compliance, it includes node data
      blob[:reports] = {}
      blob[:profiles] = {}
      Chef::Log.info "Control Profile: #{profiles}"
      profiles.each { |profile|
        Chef::Log.info "Control Profile: #{profile}"
        Chef::Log.info "Compliance Profiles: #{compliance_profiles}"
        namespace = compliance_profiles.select { |entry| entry[:profile_id] == profile }
        unless namespace.nil? && namespace.empty?
          Chef::Log.debug "Namespace for #{profile} is #{namespace[0][:owner]}"
          blob[:profiles][profile.to_sym] = namespace[0][:owner]
          blob[:reports][profile.to_sym] = report.dup
          # filter controls by profile_id
          blob[:reports][profile.to_sym][:controls] = blob[:reports][profile.to_sym][:controls].select { |control| control[:profile_id] == profile }
        else
          Chef::Log.warn "Could not determine compliance namespace for #{profile}"
        end
      }

      blob
    end

    # transforms a full InSpec json report to a min InSpec json report
    def transform(full_report)
      min_report = {}
      min_report[:version] = full_report[:version]

      # iterate over each profile and control
      min_report[:controls] = []
      full_report[:profiles].each { |profile|
        min_report[:controls] += profile[:controls].map { |control|
          control[:results].map { |result|
            c = {}
            c[:id] = control[:id]
            c[:profile_id] = profile[:name]
            c[:status] = result[:status]
            c[:code_desc] = result[:code_desc]
            c
          }
        }
      }
      min_report[:controls].flatten!
      min_report[:statistics] = full_report[:statistics]
      min_report
    end

    private

    # this is a helper methods to extract the profiles we scan and hand this
    # over to the reporter in addition to the `json-min` report. `json-min`
    # reports do not include information about the source of the profiles
    # TODO: should be available in inspec `json-min` reports out-of-the-box
    # TODO: raise warning when not a compliance-known profile
    def cc_profile_index(profiles)
      cc_profiles = tests_for_runner(profiles).select { |profile| profile[:compliance] }.map { |profile| profile[:compliance] }.uniq.compact
      cc_profiles.map { |profile|
        owner, profile_id = profile.split('/')
        {
          owner: owner,
          profile_id: profile_id,
        }
      }
    end
  end
end
