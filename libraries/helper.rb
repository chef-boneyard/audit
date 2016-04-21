# encoding: utf-8

# This helps to construct compliance urls
module ComplianceHelpers
  def construct_url(url, server = nil)
    url.sub!(%r{^/}, '') # sanitize input

    if server && server.is_a?(URI) # get directly from compliance
      # optional overrides
      server.port = port if port
      server.path = server.path + url if url
      server
    else # stream through chef-server
      chef = URI(Chef::Config[:chef_server_url])
      chef.path = '/compliance/' + url if url
      chef
    end
  end

  #rubocop:disable all
  def with_http_rescue(&block)
    begin
      return yield
    rescue Net::HTTPServerException => e
      case e.message
      when /401/
        Chef::Log.error "#{e} Possible time/date issue on the client."
      when /403/
        Chef::Log.error "#{e} Possible offline Compliance Server or chef_gate auth issue."
      end
      Chef::Log.error 'Profile NOT downloaded. Will use cached version if available.'
      raise e if run_context.node.audit.raise_if_unreachable
    end
  end
end
