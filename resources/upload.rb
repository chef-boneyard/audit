# encoding: utf-8

provides :compliance_upload
resource_name :compliance_upload

property :path, String
property :owner, String, required: true
property :server, [String, URI, nil]
property :insecure, [TrueClass, FalseClass], default: false
property :overwrite, [TrueClass, FalseClass], default: true
property :refresh_token, String
property :profile_name, String

default_action :upload

# upload profile to compliance server
action :upload do
  converge_by 'run profile validation checks' do
    load_inspec_libs
    Chef::Log.error 'Path to profile archive not specified' if path.nil?
    Chef::Log.error "Profile archive file #{path} does not exist." unless ::File.exist?(path)
    profile = Inspec::Profile.for_target(path, {})
    result = profile.check
    Chef::Log.info result[:summary].inspect
    Chef::Log.error 'Profile check failed' unless result[:summary][:valid]
    Chef::Log.info 'Profile is valid'
  end

  converge_by 'upload compliance profile' do
    access_token = retrieve_access_token(server, refresh_token, insecure)

    Chef::Log.error 'Unable to read access token, aborting upload' unless access_token
    config = Compliance::Configuration.new
    config['token'] = access_token
    config['insecure'] = insecure
    config['server'] = server
    config['version'] = compliance_version
    if check_existence(config, "#{profile_name}/#{path}") && !overwrite
      Chef::Log.error 'Profile exists on the server, use property `overwrite`'
    else
      success, msg = upload_profile(config, owner, profile_name, path)
      if success
        Chef::Log.info 'Successfully uploaded profile'
      else
        Chef::Log.error "Error during profile upload: #{msg}"
      end
    end
  end
end
