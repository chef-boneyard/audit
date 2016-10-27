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
end
