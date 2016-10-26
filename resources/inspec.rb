# encoding: utf-8

provides :inspec
resource_name :inspec

property :version, String, default: 'latest'
property :path, String
property :owner, String, required: true
property :server, [String, URI, nil]
property :insecure, [TrueClass, FalseClass], default: false
property :overwrite, [TrueClass, FalseClass], default: true
property :refresh_token, String
property :profile_name, String

default_action :install

# installs inspec if required
action :install do
  converge_by 'install/update inspec' do
    chef_gem 'inspec' do
      version new_resource.version if new_resource.version != 'latest'
      compile_time true
      action :install
    end
  end

  converge_by 'verifies the inspec version' do
    verify_inspec_version version
  end
end

action :upload do
  converge_by 'run profile validation checks' do
    raise 'Path to profile archive not specified' if path.nil?
    raise "Profile archive file #{path} does not exist." unless ::File.exist?(path)
    profile = Inspec::Profile.for_target(path, {})
    error_count = 0
    lambda { |msg|
      error_count += 1
      Chef::Log.error msg
    }
    result = profile.check
    Chef::Log.info result[:summary].inspect
    raise 'Profile check failed' unless result[:summary][:valid]
    Chef::Log.info 'Profile is valid'
  end

  converge_by 'upload compliance profile' do
    access_token = retrieve_access_token(server_url, refresh_token, insecure)

    raise 'Unable to read access token, aborting upload' unless access_token
    config = Compliance::Configuration.new
    config['token'] = access_token
    config['insecure'] = insecure
    config['server'] = server
    config['version'] = get_compliance_version
    if check_existence(config, "#{profile_name}/#{path}") && !overwrite
      raise 'Profile exists on the server, use property `overwrite`'
    else
      success, msg = upload_profile
      if success
        Chef::Log.info 'Successfully uploaded profile'
      else
        Chef::Log.error "Error during profile upload: #{msg}"
      end
    end
  end
end

def verify_inspec_version(inspec_version)
  require 'inspec'
  # check we have the right inspec version
  if Inspec::VERSION != inspec_version && inspec_version !='latest'
    Chef::Log.warn "Wrong version of inspec (#{Inspec::VERSION}), please "\
      'remove old versions (/opt/chef/embedded/bin/gem uninstall inspec).'
  else
    Chef::Log.warn "Using inspec version: (#{Inspec::VERSION})"
  end
end
