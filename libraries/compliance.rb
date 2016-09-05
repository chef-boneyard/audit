# encoding: utf-8

# exchanges a refresh token into an access token
def retrieve_access_token(server_url, refresh_token, insecure)
  require 'inspec'
  require 'bundles/inspec-compliance/api'
  require 'bundles/inspec-compliance/http'
  success, msg, access_token = Compliance::API.post_refresh_token(server_url, refresh_token, insecure)
  # TODO: we return always the access token, without proper error handling
  unless success
    Chef::Log.error("Unable to get a Chef Compliance API access_token: #{msg}")
  end
  access_token
end
