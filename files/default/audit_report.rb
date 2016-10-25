require 'chef/handler'
include ReportHelpers

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      def report
        load_needed_dependencies
        call
        send_report
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

      def set_json_format
        reporter = node['audit']['collector']
        if reporter == 'chef-visibility'
          format = 'json'
        else
          format = 'json-min'
        end
        format
      end

      def call
        Chef::Log.debug 'Initialize InSpec'
        format = set_json_format
        opts = { 'format' => format, 'output' => node['audit']['output'] }
        runner = ::Inspec::Runner.new(opts)

        tests = tests_for_runner
        tests.each { |target| runner.add_target(target, opts) }

        Chef::Log.debug 'Running tests from: #{tests.inspect}'
        runner.run
      end

      def send_report
        reporter = node['audit']['collector']
        Chef::Log.debug 'Reporting to #{reporter}'

        if reporter == 'chef-visibility'
          Collector::ChefVisibility.new(entity_uuid, run_id, run_context.node.name).send_report
        end
      end
    end
  end
end
