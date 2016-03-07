require 'tempfile'
require 'uri'

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

  default_action :execute

  action :fetch do
    converge_by 'install/update inspec' do
      chef_gem 'inspec' do
        compile_time true
      end
      require 'inspec'
    end

    converge_by 'fetch compliance profile' do
      o, p = normalize_owner_profile
      url = construct_url("organizations/#{org}/owners/#{o}/compliance/#{p}/tar")
      # puts "url = #{url}"

      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none

      rest = Chef::ServerAPI.new(url, Chef::Config)
      tf = rest.binmode_streaming_request(url)

      # don't delete temp file on GC
      ObjectSpace.undefine_finalizer(tf)

      path = get_path
      directory(::Pathname.new(path).dirname.to_s).run_action(:create)

      ::File.rename(tf.path, path)
      # tf.unlink
    end
  end

  action :execute do
    # ensure it's there, if if the profile wasn't fetched using these resources
    converge_by 'install/update inspec' do
      chef_gem 'inspec' do
        compile_time true
      end
      require 'inspec'
    end

    converge_by 'execute compliance profile' do
      reports = {}
      path = get_path
      report_file = get_report

      ## TODO: flesh out inspec's report CLI interface,
      ##       make this an execute[inspec check ...]
      inspec = ::Inspec::Runner.new('report' => true)
      inspec.add_tests([path])
      begin
        inspec.run
      rescue Chef::Exceptions::ValidationFailed => e # XXX weird exception
        # log "INSPEC #{e}"
      end

      file report_file do
        content inspec.report.to_json
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

  def get_path
    return path if path

    o, p = normalize_owner_profile
    ::File.join(Chef::Config[:file_cache_path], 'compliance', "#{owner}_#{profile}.tgz")
  end

  def get_report
    o, p = normalize_owner_profile
    ::File.join(Chef::Config[:file_cache_path], 'compliance', "#{owner}_#{profile}_report.json")
  end

  def org
    Chef::Config[:chef_server_url].split('/').last
  end
end
