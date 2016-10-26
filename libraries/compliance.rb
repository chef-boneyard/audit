# encoding: utf-8

# exchanges a refresh token into an access token
def retrieve_access_token(server_url, refresh_token, insecure)
  require 'inspec'
  require 'bundles/inspec-compliance/api'
  require 'bundles/inspec-compliance/http'
  require 'bundles/inspec-compliance/configuration'
  # get_token_via_refresh_token is provided by the inspec-compliance plugin bundled in InSpec
  success, msg, access_token = Compliance::API.get_token_via_refresh_token(server_url, refresh_token, insecure)
  unless success
    Chef::Log.error("Unable to get a Chef Compliance API access_token: #{msg}")
  end
  access_token
end

def get_compliance_version
  Compliance::API.version(server, insecure)
end

def check_existence(config, path)
  Compliance::API.exist?(config, path)
end

def upload_profile(config, owner, profile_name, path)
  Compliance::API.upload(config, owner, profile_name, path)
end
