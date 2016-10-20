require 'chef/handler'
include ReportHelpers

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      def report
        reporter = node['audit']['collector']
        server = node['audit']['server']
        user = node['audit']['owner']
        token = node['audit']['token'] || node['audit']['refresh_token']

        load_needed_dependencies
        call(reporter, server, user, token)
        send_report(reporter, server, user, token)
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

      def get_tests_for_runner
        node['audit']['profiles']
      end

      def login_to_compliance(server, user, token)
        cmd = "inspec compliance login #{server} --user #{user} --insecure --refresh-token #{token}"
        system(cmd)
      end

      def call(reporter, server, user, token)
        Chef::Log.debug 'Initialize InSpec'
        login_to_compliance(server, user, token) if reporter == 'chef-compliance'
        format = reporter == 'chef-visibility' ? format = 'json' : 'json-min'
        Chef::Log.warn "*********** Directory is  #{node['audit']['output']}"
        opts = { 'format' => format, 'output' => node['audit']['output'] }
        runner = ::Inspec::Runner.new(opts)

        tests = tests_for_runner
        tests.each { |target| runner.add_target(target, opts) }

        Chef::Log.info "Running tests from: #{tests.inspect}"
        runner.run
      end

      def send_report(reporter, server, user, token)
        Chef::Log.info "Reporting to #{reporter}"

        if reporter == 'chef-visibility'
          Collector::ChefVisibility.new(entity_uuid, run_id, run_context.node.name).send_report

        elsif reporter == 'chef-compliance'
          raise_if_unreachable = node['audit']['raise_if_unreachable']
          url = construct_url(server, File.join('/owners', user, 'inspec'))
          if token && server
            Collector::ChefCompliance.new(url, token, raise_if_unreachable).send_report
          else
            Chef::Log.warn "'server' and 'token' properties required by inspec report collector #{reporter}. Skipping..."
          end

        elsif reporter == 'chef-server'
          chef_url = server || base_chef_server_url
          if chef_url
            url = construct_url(chef_url + '/compliance/', File.join('organizations', user, 'inspec'))
            Collector::ChefServer.new(url).send_report
          else
            Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
          end
        else
          Chef::Log.warn "#{reporter} is not a supported inspec report collector"
        end
      end
    end
  end
end
