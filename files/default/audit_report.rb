# encoding: utf-8

require 'chef/handler'

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      def report
        return if audit_scheduler.should_skip_audit?

        ensure_inspec_installed
        report_results = initialize_report_results
        compliance_profiles.each do |profile|
          profile.fetch
        end
        compliance_profiles.each do |profile|
          json = profile.execute
          report_results[:reports][profile.name] = ::JSON.parse(json)
          # TODO: count up and log results
        end
        report_results[:profile] = Hash[compliance_profiles.map {|profile| [profile.owner, profile.name] }.flatten]
        server_connection.report_results(report_results)
      end

      def audit_scheduler
        @audit_scheduler ||= ::Audit::AuditScheduler.new(node['audit']['interval']['enabled'], node['audit']['interval']['time'])
      end

      def initialize_report_results
        report_results = {
                           node: node['name'],
                           os: {
                             # arch: os[:arch],
                             release: node['platform_version'],
                             family: node['platform'],
                           },
                           environment: node['environment'],
                         }
        Chef::Log.debug "Initialized report results on node #{report_results['node']} and environment #{report_results['environment']}"
      end

      def inspec_version
        node['audit']['inspec_version']
      end

      def ensure_inspec_installed
        Chef::Log.debug "Ensuring inspec #{inspec_version} is installed" 
        require 'inspec'
        # load the supermarket plugin
        require 'bundles/inspec-supermarket/api'
        require 'bundles/inspec-supermarket/target'

        # load the compliance api plugin
        require 'bundles/inspec-compliance/api'

        if Inspec::VERSION != inspec_version && inspec_version != 'latest'
          Chef::Log.warn "Wrong version of inspec (#{Inspec::VERSION}), please "\
            'remove old versions (/opt/chef/embedded/bin/gem uninstall inspec).'
        else
          Chef::Log.warn "Using inspec version: (#{Inspec::VERSION})"
        end
      end

      def compliance_profiles
        @compliance_profiles ||= initialize_compliance_profiles 
      end

      def initialize_compliance_profiles
        profiles = []
        node['audit']['profiles'].each do |owner_profile, value|
          case value
          when Hash
            enabled = !value['disabled']
            path = value['source']
          else
            enabled = value
          end
          fail "Invalid profile name '#{owner_profile}'. "\
            "Must contain /, e.g. 'john/ssh'" if owner_profile !~ %r{\/}
          owner, name = owner_profile.split('/').last(2)
          platform_windows = node['platform'] == 'windows'
          quiet = node['audit']['quiet']
          profiles.push ::Audit::ComplianceProfile.new(owner, name, enabled, path, server_connection, platform_windows, quiet)
        end
        profiles
      end

      def server_connection
        @server_connection ||= initialize_server_connection
      end

      def initialize_server_connection
        token = node['audit']['token']
        server = node['audit']['server']
        unless token.nil?
          Chef::Log.info "Connecting to compliance server #{server} with provided token"
          org = node['audit']['owner']
          org = parse_org(server) if org.nil?
          ::Audit::ComplianceServerConnection.new(server, org, token, node['audit']['refresh_token'])
        else
          server = chef_server_url if server.nil?
          org = parse_org(server)
          base_server = server
          base_server.slice!("/organizations/#{org}")
          Chef::Log.info "Connecting to chef server #{server}"
          ::Audit::ChefServerConnection.new(base_server, org)
        end
      end

      def chef_server_url
        Chef::Config[:chef_server_url]
      end

      def parse_org(url)
        url.split('/').last
      end
    end
  end
end
