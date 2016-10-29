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
        token = node['audit']['token']
        refresh_token = node['audit']['refresh_token']
        interval = node['audit']['interval']
        interval_enabled = node['audit']['interval']['enabled']
        interval_time = node['audit']['interval']['time']
        profiles = node['audit']['profiles']
        quiet = node['audit']['quiet']
        write_to_file = node['audit']['write_to_file']

        # used to ensure there are no conflicting attributes (see libraries/helper.rb)
        if check_attributes(write_to_file, interval_enabled) == false
          Chef::Log.error 'Please have a look at your attributes. Only one each of interval enabled and write to file may be set to true for filename writing purposes.'
        end

        # load inspec, supermarket bundle and compliance bundle
        load_needed_dependencies

        # ensure authentication for Chef Compliance is in place, see libraries/compliance.rb
        login_to_compliance(server, user, token, refresh_token) if reporter == 'chef-compliance'

        # true if profile is due to run (see libraries/helper.rb)
        if check_interval_settings(interval, interval_enabled, interval_time, profiles)
          # return hash of opts to be used by runner
          opts = get_opts(reporter, quiet)

          # instantiate inspec runner with given options and run profiles; return report
          report = call(opts, profiles)

          # creates file on disk if interval reporting is enabled or write_to_file is enabled (see libraries/helper.rb)
          write_to_file(report, profiles, interval_enabled, write_to_file) if interval_enabled || write_to_file

          # send report to the correct reporter (visibility, compliance, chef-server)
          send_report(reporter, server, user, profiles, report)
        else
          Chef::Log.error 'Please take a look at your interval settings'
        end
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

      # sets format to json-min when chef-compliance, json when chef-visibility
      def get_opts(reporter, quiet)
        format = reporter == 'chef-visibility' ? 'json' : 'json-min'
        output = quiet ? ::File::NULL : $stdout
        Chef::Log.warn "Format is #{format}"
        { 'report' => true, 'format' => format, 'output' => output }
      end

      # run profiles and return report
      def call(opts, profiles)
        Chef::Log.debug 'Initialize InSpec'
        Chef::Log.debug "Options are set to: #{opts}"
        runner = ::Inspec::Runner.new(opts)

        # parse profile hashes for runner, see libraries/helper.rb
        tests = tests_for_runner(profiles)
        tests.each { |target| runner.add_target(target, opts) }

        Chef::Log.info "Running tests from: #{tests.inspect}"
        runner.run
        runner.report.to_json
      end

      # extracts relevant node data
      def gather_nodeinfo
        n = run_context.node
        {
          node: n.name,
          os: {
            # arch: n['arch'],
            release: n['platform_version'],
            family: n['platform'],
          },
          environment: n.environment,
        }
      end

      # send report to the collector (see libraries/collector_classes.rb)
      def send_report(reporter, server, user, profiles, report)
        Chef::Log.info "Reporting to #{reporter}"

        # TODO: harmonize reporter interface
        if reporter == 'chef-visibility'
          Collector::ChefVisibility.new(entity_uuid, run_id, gather_nodeinfo, report).send_report

        elsif reporter == 'chef-compliance'
          raise_if_unreachable = node['audit']['raise_if_unreachable']
          url = construct_url(server, File.join('/owners', user, 'inspec'))
          if server
            # TODO: we should not send the profiles to the reporter, all the information
            # should be available in inspec reports out-of-the-box
            # TODO: Chef Compliance can only handle reports for profiles it knows
            profiles = tests_for_runner(profiles).map { |profile| profile[:compliance] }.uniq
            compliance_profiles = profiles.map { |profile|
              owner, profile_id = profile.split('/')
              {
                owner: owner,
                profile_id: profile_id,
              }
            }
            Collector::ChefCompliance.new(url, gather_nodeinfo, raise_if_unreachable, compliance_profiles, report).send_report
          else
            Chef::Log.warn "'server' and 'token' properties required by inspec report collector #{reporter}. Skipping..."
          end

        # elsif reporter == 'chef-server'
        #   chef_url = server || base_chef_server_url
        #   if chef_url
        #     url = construct_url(chef_url + '/compliance/', File.join('organizations', user, 'inspec'))
        #     Collector::ChefServer.new(url).send_report
        #   else
        #     Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
        #   end
        else
          Chef::Log.warn "#{reporter} is not a supported InSpec report collector"
        end
      end
    end
  end
end
