# encoding: utf-8
# author: Christoph Hartmann

require 'uri'

require 'bundles/inspec-compliance/target'
require 'inspec/fetcher'
require 'inspec/errors'

# This class implements an InSpec fetcher for for Chef Server. The implementation
# is based on the Chef Compliance fetcher and only adapts the calls to redirect
# the requests via Chef Server.
#
# This implementation depends on chef-client runtime, therefore it is only executable
# inside of a chef-client run
module ChefServer
  class Fetcher < Compliance::Fetcher
    name 'chef-server'

    # it positions itself before `compliance` fetcher
    # only load it, if the Chef Server is integrated with Chef Compliance
    priority 501

    def self.resolve(target)
      uri = if target.is_a?(String) && URI(target).scheme == 'compliance'
              URI(target)
            elsif target.respond_to?(:key?) && target.key?(:compliance)
              URI("compliance://#{target[:compliance]}")
            end

      return nil if uri.nil?

      profile = uri.host + uri.path
      profile = uri.user + '@' + profile if uri.user

      config = {
        'insecure' => true,
      }

      if target.respond_to?(:key?) && target.key?(:version)
        new(target_url(profile, config, target[:version]), config)
      else
        new(target_url(profile, config), config)
      end
    rescue URI::Error => _e
      nil
    end

    def self.chef_server_url_base
      cs = URI(Chef::Config[:chef_server_url])
      cs.path = ''
      cs.to_s
    end

    def self.chef_server_org
      Chef::Config[:chef_server_url].split('/').last
    end

    def self.url_prefix
      return '/compliance' if chef_server_reporter? || chef_server_fetcher?
      ''
    end

    def self.target_url(profile, config, version = nil)
      o, p = profile.split('/')
      reqpath = if version
                  "organizations/#{chef_server_org}/owners/#{o}/compliance/#{p}/version/#{version}/tar"
                else
                  "organizations/#{chef_server_org}/owners/#{o}/compliance/#{p}/tar"
                end

      if config['insecure']
        Chef::Config[:verify_api_cert] = false
        Chef::Config[:ssl_verify_mode] = :verify_none
      end

      target_url = construct_url(chef_server_url_base + url_prefix + '/', reqpath)
      Chef::Log.info("Fetching profile from: #{target_url}")
      target_url
    end

    #
    # We want to save compliance: in the lockfile rather than url: to
    # make sure we go back through the ComplianceAPI handling.
    #
    def resolved_source
      { compliance: chef_server_url }
    end

    # Downloads archive to temporary file using a Chef::ServerAPI
    # client so that Chef Server's header-based authentication can be
    # used.
    def download_archive_to_temp
      return @temp_archive_path unless @temp_archive_path.nil?

      Chef::Config[:verify_api_cert] = false # FIXME
      Chef::Config[:ssl_verify_mode] = :verify_none # FIXME

      rest = Chef::ServerAPI.new(@target, Chef::Config)
      archive = with_http_rescue do
        rest.streaming_request(@target)
      end
      @archive_type = '.tar.gz'
      raise "Unable to find requested profile on path: '#{target_path}' on the Automate system." if archive.nil?
      Inspec::Log.debug("Archive stored at temporary location: #{archive.path}")
      @temp_archive_path = archive.path
    end

    def to_s
      'Chef Server/Compliance Profile Loader'
    end

    # internal class methods
    def self.chef_server_reporter?
      return false unless defined?(Chef) && defined?(Chef.node) && defined?(Chef.node.attributes)
      reporters = get_reporters(Chef.node.attributes['audit'])
      # TODO: harmonize with audit_report.rb load_chef_fetcher
      Chef.node.attributes['audit'] && (
        reporters.include?('chef-server') ||
        reporters.include?('chef-server-compliance') ||
        reporters.include?('chef-server-visibility') ||
        reporters.include?('chef-server-automate')
      )
    end

    def self.chef_server_fetcher?
      # TODO: harmonize with audit_report.rb load_chef_fetcher
      %w{chef-server chef-server-compliance chef-server-visibility chef-server-automate}.include?(Chef.node.attributes['audit']['fetcher'])
    end

    private

    def chef_server_url
      m = %r{^#{@config['server']}/owners/(?<owner>[^/]+)/compliance/(?<id>[^/]+)/tar$}.match(@target)
      "#{m[:owner]}/#{m[:id]}"
    end

    def target_path
      return @target.path if @target.respond_to?(:path)
      @target
    end
  end
end
