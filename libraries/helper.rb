# encoding: utf-8
require 'uri'

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
    # sanitize inputs
    server << '/' unless server =~ %r{/\z}
    path.sub!(%r{^/}, '')
    server = URI(server)
    server.path = server.path + path if path
    server
  end

  def handle_http_error_code(code)
    case code
    when /401|403/
      Chef::Log.error 'Auth issue: see audit cookbook TROUBLESHOOTING.md'
    when /404/
      Chef::Log.error 'Object does not exist on remote server.'
    end
    msg = "Received HTTP error #{code}"
    Chef::Log.error msg
    raise msg if @raise_if_unreachable
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
      Chef::Log.error e
      handle_http_error_code(e.response.code)
    end
  end

  # Returns the uuid for the current converge
  def run_id
    return unless run_context &&
                  run_context.events &&
                  run_context.events.subscribers.is_a?(Array)
    run_context.events.subscribers.each do |sub|
      if (sub.class == Chef::ResourceReporter && defined?(sub.run_id))
        return sub.run_id
      end
    end
    return nil
  end

  # Returns the node's uuid
  def entity_uuid
    if (defined?(Chef) &&
        defined?(Chef::DataCollector) &&
        defined?(Chef::DataCollector::Messages) &&
        defined?(Chef::DataCollector::Messages.node_uuid))
      return Chef::DataCollector::Messages.node_uuid
    end
  end
end
