# encoding: utf-8

module ReportHelpers
  # Returns the uuid for the current converge
  def run_id
    return unless run_context &&
                  run_context.events &&
                  run_context.events.subscribers.is_a?(Array)
    run_context.events.subscribers.each do |sub|
      if sub.class == Chef::ResourceReporter && defined?(sub.run_id)
        return sub.run_id
      end
    end
    nil
  end

  # Returns the node's uuid
  def entity_uuid
    if defined?(Chef) &&
       defined?(Chef::DataCollector) &&
       defined?(Chef::DataCollector::Messages) &&
       defined?(Chef::DataCollector::Messages.node_uuid)
      return Chef::DataCollector::Messages.node_uuid
    end
  end

  # Convert the strings in the profile definitions into symbols for handling
  def tests_for_runner
    tests = node['audit']['profiles']
    tests_for_runner = tests.map { |test| Hash[test.map { |k, v| [k.to_sym, v] }] }
    tests_for_runner
  end

  def construct_url(server, path)
    # sanitize inputs
    server << '/' unless server =~ %r{/\z}
    path.sub!(%r{^/}, '')
    server = URI(server)
    server.path = server.path + path if path
    server
  end

  def with_http_rescue(*)
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

  def base_chef_server_url
    cs = URI(Chef::Config[:chef_server_url])
    cs.path = ''
    cs.to_s
  end

  # get file contents where inspec results were saved
  def results
    result_path = File.expand_path('../../inspec_results.json', __FILE__)
    file = File.open(result_path, 'rb')
    content = file.read
    file.close
    content
  end
end
