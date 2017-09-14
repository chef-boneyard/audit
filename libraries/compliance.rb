# encoding: utf-8

# load all the inspec and compliance bundle requirements
def load_inspec_libs
  require 'inspec'
  if Inspec::VERSION != node['audit']['inspec_version'] && node['audit']['inspec_version'] !='latest'
    Chef::Log.warn "Wrong version of inspec (#{Inspec::VERSION}), please "\
      'remove old versions (/opt/chef/embedded/bin/gem uninstall inspec).'
  else
    Chef::Log.info "Using inspec version: (#{Inspec::VERSION})"
  end
  require 'bundles/inspec-compliance/api'
  require 'bundles/inspec-compliance/http'
  require 'bundles/inspec-compliance/configuration'
end

# exchanges refresh token for access token. access token is needed
# to get a proper config to talk with the compliance api
def retrieve_access_token(server_url, refresh_token, insecure)
  success, msg, access_token = Compliance::API.get_token_via_refresh_token(server_url, refresh_token, insecure)
  unless success
    Chef::Log.error("Unable to get a Chef Compliance API access_token: #{msg}")
  end
  access_token
end

# used for compliance config
def compliance_version(config)
  Compliance::API.version(config)
end

# check if profile already exists on compliance server
def check_existence(config, path)
  Compliance::API.exist?(config, path)
end

# upload profile to compliance server
def upload_profile(config, owner, profile_name, path)
  Compliance::API.upload(config, owner, profile_name, path)
end

# TODO: temporary, we should use a stateless approach
# TODO: harmonize with CLI store_access_token(url, user, token, insecure)
def login_to_compliance(server, user, access_token, refresh_token)
  if !refresh_token.nil?
    success, msg, access_token = Compliance::API.get_token_via_refresh_token(server, refresh_token, true)
  else
    success = true
  end

  if success
    config = Compliance::Configuration.new
    config.clean
    config['server'] = server
    config['insecure'] = true
    config['user'] = user
    config['token'] = access_token
    config['server_type'] = 'compliance'
    config['version'] = Compliance::API.version(config)
    config.store
  else
    Chef::Log.error msg
    raise('Could not store authentication token')
  end
end
