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
      config = {
        'insecure' => true,
      }
      new(target_url(profile, config), config)
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

    def self.target_url(profile, config)
      o, p = profile.split('/')
      reqpath ="organizations/#{chef_server_org}/owners/#{o}/compliance/#{p}/tar"

      if config['insecure']
        Chef::Config[:verify_api_cert] = false
        Chef::Config[:ssl_verify_mode] = :verify_none
      end

      construct_url(chef_server_url_base + url_prefix + '/', reqpath)
    end

    #
    # We want to save compliance: in the lockfile rather than url: to
    # make sure we go back through the ComplianceAPI handling.
    #
    def resolved_source
      { compliance: chef_server_url }
    end

    # Downloads archive to temporary file from Chef Compliance via Chef Server
    def download_archive_to_temp
      return @temp_archive_path if !@temp_archive_path.nil?
      Inspec::Log.debug("Fetching URL: #{@target}")

      Chef::Config[:verify_api_cert] = false # FIXME
      Chef::Config[:ssl_verify_mode] = :verify_none # FIXME

      rest = Chef::ServerAPI.new(@target, Chef::Config)
      archive = with_http_rescue do
        rest.streaming_request(@target)
      end
      @archive_type = '.tar.gz'
      Inspec::Log.debug("Archive stored at temporary location: #{archive.path}")
      @temp_archive_path = archive.path
    end

    def to_s
      'Chef Server/Compliance Profile Loader'
    end

    # internal class methods
    def self.chef_server_reporter?
      return false if !(defined?(Chef) && defined?(Chef.node) && defined?(Chef.node.attributes))
      reporters = get_reporters(Chef.node.attributes['audit'])
      Chef.node.attributes['audit'] && (
        reporters.include?('chef-server-visibility') ||
        reporters.include?('chef-server-automate')
      )
    end

    def self.chef_server_fetcher?
      Chef.node.attributes['audit']['fetcher'] == 'chef-server'
    end

    private

    def chef_server_url
      m = %r{^#{@config['server']}/owners/(?<owner>[^/]+)/compliance/(?<id>[^/]+)/tar$}.match(@target)
      "#{m[:owner]}/#{m[:id]}"
    end
  end
end
