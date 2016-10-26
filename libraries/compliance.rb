# encoding: utf-8

# load all the inspec and compliance bundle requirements
def load_inspec_libs
  require 'inspec'
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
def compliance_version
  Compliance::API.version(server, insecure)
end

# check if profile already exists on compliance server
def check_existence(config, path)
  Compliance::API.exist?(config, path)
end

# upload profile to compliance server
def upload_profile(config, owner, profile_name, path)
  Compliance::API.upload(config, owner, profile_name, path)
end
