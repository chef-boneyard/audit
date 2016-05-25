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

  #rubocop:disable all
  def with_http_rescue(&block)
    begin
      return yield
    rescue Net::HTTPServerException => e
      case e.response.code
      when /401/
        Chef::Log.error "Possible time/date issue on the client."
      when /403/
        Chef::Log.error "Possible offline Compliance Server or chef_gate auth issue."
      when /404/
        Chef::Log.error "Object does not exist on remote server."
      end
      Chef::Log.error e.message
      raise e if run_context.node.audit.raise_if_unreachable
    end
  end

  # exchanges a refresh token into an access token
  def retrieve_access_token(server, refresh_token)
    success, msg, access_token = Compliance::API.post_refresh_token(url, refresh_token, options['insecure'])
    # TODO we return always the access token, without proper error handling
    access_token
  end
end
