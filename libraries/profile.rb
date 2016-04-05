# encoding: utf-8
require 'tempfile'
require 'uri'
require 'net/https'
require 'fileutils'

# `compliance_profile` custom resource to collect and run Chef Compliance
# profiles
class ComplianceProfile < Chef::Resource
  include ComplianceHelpers
  use_automatic_resource_name

  property :profile, String, name_property: true
  property :owner, String, required: true

  # to use a chef-compliance server that is _not_ "colocated" with chef-server
  property :server, URI
  property :port, Integer
  property :username, String
  property :password, String
  property :token, String
  # TODO(sr) it might be nice to default to settings from attributes

  # alternative to (owner, profile)-addressing for profiles,
  # e.g. for running profiles from disk (coming from some other source)
  property :path, String

  inspec_version = '0.15.0'

  default_action :execute

  action :fetch do
    converge_by 'install/update inspec' do
      chef_gem 'inspec' do
        version inspec_version
        compile_time true
      end

      require 'inspec'

      unless Inspec::VERSION == inspec_version
        Chef::Log.warn "Wrong version of inspec (#{Inspec::VERSION}), please "\
          'remove old versions (/opt/chef/embedded/bin/gem uninstall inspec).'
      end
    end

    converge_by 'fetch compliance profile' do
      o, p = normalize_owner_profile
      Chef::Log.info "Fetch compliance profile #{o}/#{p}"
      reqpath ="organizations/#{org}/owners/#{o}/compliance/#{p}/tar"

      path = tar_path
      directory(::Pathname.new(path).dirname.to_s).run_action(:create)

      if token # go direct
        url = construct_url(reqpath, server)

        Net::HTTP.start(url.host, url.port) do |http|
          http.use_ssl = url.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE # FIXME

          resp = http.get(url.path, 'Authorization' => "Bearer #{token}")
          tf = Tempfile.new('foo', Dir.tmpdir, 'wb+')
          tf.binmode
          tf.write(resp.body)
          tf.flush
        end
      else # go through Chef::ServerAPI
        url = construct_url(reqpath)
        Chef::Config[:verify_api_cert] = false # FIXME
        Chef::Config[:ssl_verify_mode] = :verify_none # FIXME

        rest = Chef::ServerAPI.new(url, Chef::Config)
        tf = rest.binmode_streaming_request(url)
      end

      FileUtils.move(tf.path, path)
    end
  end

  action :execute do
    # ensure it's there, if if the profile wasn't fetched using these resources
    converge_by 'install/update inspec' do
      chef_gem 'inspec' do
        version inspec_version
        compile_time true
      end

      require 'inspec'

      unless Inspec::VERSION == inspec_version
        Chef::Log.warn "Wrong version of inspec (#{Inspec::VERSION}), please "\
          'remove old versions (/opt/chef/embedded/bin/gem uninstall inspec).'
      end
    end

    converge_by 'execute compliance profile' do
      path = tar_path
      report_file = report_path

      o, p = normalize_owner_profile
      Chef::Log.info "Execute compliance profile #{o}/#{p}"

      # TODO: flesh out inspec's report CLI interface,
      #       make this an execute[inspec check ...]
      runner = ::Inspec::Runner.new('report' => true)
      runner.add_target(path, {})
      begin
        runner.run
      # TODO: weird exception, do we need that handling?
      rescue Chef::Exceptions::ValidationFailed => e
        log "INSPEC #{e}"
      end

      file report_file do
        content runner.report.to_json
        sensitive true
      end
    end
  end

  def normalize_owner_profile
    if profile.include?('/')
      profile.split('/')
    else
      [owner || 'base', profile]
    end
  end

  def tar_path
    return path if path
    o, p = normalize_owner_profile
    ::File.join(Chef::Config[:file_cache_path], 'compliance', "#{o}_#{p}.tgz")
  end

  def report_path
    o, p = normalize_owner_profile
    ::File.join(Chef::Config[:file_cache_path], 'compliance', "#{o}_#{p}_report.json")
  end

  def org
    Chef::Config[:chef_server_url].split('/').last
  end
end
