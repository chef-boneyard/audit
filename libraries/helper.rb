# encoding: utf-8

# This helps to construct compliance urls
module ComplianceHelpers
  # returns the base url of the chef server
  # Chef::Config[:chef_server_url] may be https://chef.compliance.test/organizations/brewinc
  # returns 'https://chef.compliance.test'
  def base_chef_server_url
    cs = URI(Chef::Config[:chef_server_url])
    cs.path = ''
    cs.to_s
  end

  def construct_url(server, path)
    path.sub!(%r{^/}, '') # sanitize input
    server = URI(server)
    server.path = server.path + path if path
    server
  end

  def handle_http_error_code(code)
    case code
    when /401/
      Chef::Log.error 'Possible time/date issue on the client.'
    when /403/
      Chef::Log.error 'Possible offline Compliance Server or chef_gate auth issue.'
    when /404/
      Chef::Log.error 'Object does not exist on remote server.'
    end
    msg = 'Could not fetch the profile. Verify the authentication (e.g. token) is set properly'
    Chef::Log.error msg
    fail msg if run_context.node.audit.raise_if_unreachable
  end

  #rubocop:disable all
  def with_http_rescue(&block)
    begin
      response = yield
      if response.respond_to?(:code)
        # handle non 200 error codes, they are not raised as Net::HTTPServerException
        handle_http_error_code(response.code) if response.code.to_i >= 300
      end
      return response
    rescue Net::HTTPServerException => e
      handle_http_error_code(e.response.code)
    end
  end

  # exchanges a refresh token into an access token
  def retrieve_access_token(server, refresh_token)
    _success, _msg, access_token = Compliance::API.post_refresh_token(url, refresh_token, options['insecure'])
    # TODO we return always the access token, without proper error handling
    access_token
  end
end
