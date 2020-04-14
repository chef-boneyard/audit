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
    # the Chef::DataCollector::Messages API here is Chef < 15.0 backcompat and can be removed when Chef 14.x is no longer supported
    node['chef_guid'] || defined?(Chef::DataCollector::Messages) && Chef::DataCollector::Messages.node_uuid
  end

  # Convert the strings in the profile definitions into symbols for handling
  def tests_for_runner(profiles)
    tests_for_runner = profiles.map { |profile| Hash[profile.map { |k, v| [k.to_sym, v] }] }
    tests_for_runner
  end

  def construct_url(server, path)
    # ensure we do not modify a frozen String
    srv = server.dup
    # sanitize inputs
    srv << '/' unless server =~ %r{/\z}
    path.sub!(%r{^/}, '')
    srv = URI(srv)
    srv.path = srv.path + path if path
    srv
  end

  def with_http_rescue(*)
    response = yield
    if response.respond_to?(:code)
      # handle non 200 error codes, they are not raised as Net::HTTPClientException
      handle_http_error_code(response.code) if response.code.to_i >= 300
    end
    response
  rescue Net::HTTPClientException => e
    Chef::Log.error e
    handle_http_error_code(e.response.code)
  end

  def handle_http_error_code(code)
    case code
    when /401|403/
      Chef::Log.error 'Auth issue: see audit cookbook TROUBLESHOOTING.md'
    when /404/
      Chef::Log.error 'Object does not exist on remote server.'
    when /413/
      Chef::Log.error 'You most likely hit the erchef request size in Chef Server that defaults to ~2MB. To increase this limit see audit cookbook TROUBLESHOOTING.md OR https://docs.chef.io/config_rb_server.html'
    when /429/
      Chef::Log.error "This error typically means the data sent was larger than Automate's limit (4 MB). Run InSpec locally to identify any controls producing large diffs."
    end
    msg = "Received HTTP error #{code}"
    Chef::Log.error msg
    raise msg if @raise_if_unreachable
  end

  def base_chef_server_url
    cs = chef_server_uri
    cs.path = ''
    cs.to_s
  end

  def chef_server_uri
    URI(Chef::Config.chef_server_url)
  end

  # used for interval timing
  def create_timestamp_file
    timestamp = Time.now.utc
    timestamp_file = File.new(report_timing_file, 'w')
    timestamp_file.puts(timestamp)
    timestamp_file.close
  end

  def report_timing_file
    # Will create and return the complete folder path for the chef cache location and the passed in value
    ::File.join(Chef::FileCache.create_cache_path('compliance'), 'report_timing.json')
  end

  def profile_overdue_to_run?(interval)
    # Calculate when a report was last created so we delay the next report if necessary
    return true unless ::File.exist?(report_timing_file)
    seconds_since_last_run = Time.now - ::File.mtime(report_timing_file)
    seconds_since_last_run > interval
  end

  def check_interval_settings(interval, interval_enabled, interval_time)
    # handle intervals
    interval_seconds = 0 # always run this by default, unless interval is defined
    if !interval.nil? && interval_enabled
      interval_seconds = interval_time * 60 # seconds in interval
      Chef::Log.debug "Auditing this machine every #{interval_seconds} seconds "
    end
    # returns true if profile is overdue to run
    profile_overdue_to_run?(interval_seconds)
  end

  # takes value of reporters and returns array to ensure backwards-compatibility
  def handle_reporters(reporters)
    return reporters if reporters.is_a? Array
    [reporters]
  end

  def cookbook_vendor_path
    File.expand_path('../../files/default/vendor', __FILE__)
  end

  def cookbook_handler_path
    File.expand_path('../../files/default/handler', __FILE__)
  end

  # Copies ['audit']['attributes'] into run_state for the audit_handler to read them later
  # Deletes ['audit']['attributes'] if instructed by ['audit']['attributes_save']
  def copy_audit_attributes
    node.run_state['audit_attributes'] = node['audit']['attributes']
    node.rm('audit', 'attributes') unless node['audit']['attributes_save']
  end

  def load_audit_handler
    libpath = ::File.join(cookbook_handler_path, 'audit_report')
    Chef::Log.info("loading handler from #{libpath}")
    $LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
    require libpath
    handler = Chef::Handler::AuditReport.new
    Chef::Config.send('report_handlers') << handler
    Chef::Config.send('exception_handlers') << handler
  end

  # taking node['audit'] as parameter so that it can be called from the chef-server fetcher as well
  # audit['collector'] is the legacy reporter,
  def get_reporters(audit)
    if audit.nil?
      Chef::Log.warn("node ['audit'] is not defined")
      return []
    end
    if audit['collector']
      Chef::Log.warn("node ['audit']['collector'] is deprecated and will be removed from the next major version of the cookbook. Please use node ['audit']['reporter']")
      return handle_reporters(audit['collector'])
    end
    handle_reporters(audit['reporter'])
  end
end

::Chef::DSL::Recipe.include ReportHelpers
