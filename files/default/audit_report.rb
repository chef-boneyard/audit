require 'chef/handler'

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      def report
        load_needed_dependencies
        call
      end

      def load_needed_dependencies
        require 'inspec'
        # load supermarket plugin, this is part of the inspec gem
        require 'bundles/inspec-supermarket/api'
        require 'bundles/inspec-supermarket/target'

        # load the compliance plugin
        require 'bundles/inspec-compliance/configuration'
        require 'bundles/inspec-compliance/support'
        require 'bundles/inspec-compliance/http'
        require 'bundles/inspec-compliance/api'
        require 'bundles/inspec-compliance/target'
      end

      def call
        Chef::Log.debug 'Initialize InSpec'
        opts = { 'format' => node['audit']['format'], 'output' => node['audit']['output'] }
        runner = ::Inspec::Runner.new(opts)

        tests = node['audit']['profiles']
        tests.each { |target| runner.add_target(target, opts) }

        Chef::Log.debug 'Running tests from: #{tests.inspect}'
        runner.run
      end
    end
  end
end
