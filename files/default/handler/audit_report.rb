require 'chef/handler'
include ReportHelpers

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      def report
        # get reporter(s) from attributes as an array
        reporters = get_reporters(node['audit'])

        # collect attribute values
        server = node['audit']['server']
        user = node['audit']['owner']
        token = node['audit']['token']
        refresh_token = node['audit']['refresh_token']
        interval = node['audit']['interval']
        interval_enabled = node['audit']['interval']['enabled']
        interval_time = node['audit']['interval']['time']
        profiles = node['audit']['profiles']
        quiet = node['audit']['quiet']

        # load inspec, supermarket bundle and compliance bundle
        load_needed_dependencies

        # detect if we run in a chef client with chef server
        load_chef_fetcher if reporters.include?('chef-server') ||
                             reporters.include?('chef-server-compliance') ||
                             reporters.include?('chef-server-visibility') ||
                             node['audit']['fetcher'] == 'chef-server'

        # iterate through reporters
        reporters.each do |reporter|
          # ensure authentication for Chef Compliance is in place, see libraries/compliance.rb
          login_to_compliance(server, user, token, refresh_token) if reporter == 'chef-compliance'

          # true if profile is due to run (see libraries/helper.rb)
          if check_interval_settings(interval, interval_enabled, interval_time)

            # create a file with a timestamp to calculate interval timing
            create_timestamp_file if interval_enabled

            # return hash of opts to be used by runner
            opts = get_opts(reporter, quiet)

            # instantiate inspec runner with given options and run profiles; return report
            report = call(opts, profiles)

            # send report to the correct reporter (visibility, compliance, chef-server)
            send_report(reporter, server, user, profiles, report)
          else
            Chef::Log.warn 'Audit run skipped due to interval configuration'
          end
        end
      end

      # overwrite the default run_report_safely to be able to throw exceptions
      def run_report_safely(run_status)
        run_report_unsafe(run_status)
      rescue Exception => e # rubocop:disable Lint/RescueException
        Chef::Log.error("Report handler #{self.class.name} raised #{e.inspect}")
        Array(e.backtrace).each { |line| Chef::Log.error(line) }
        # force a chef-client exception if user requested it
        throw e if node['audit']['fail_if_not_present']
      ensure
        @run_status = nil
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

      # we expect inspec to be loaded before
      def load_chef_fetcher
        Chef::Log.debug "Load vendored ruby files from: #{cookbook_vendor_path}"
        $LOAD_PATH.unshift(cookbook_vendor_path)
        require 'chef-server/fetcher'
      end

      # sets format to json-min when chef-compliance, json when chef-visibility
      def get_opts(reporter, quiet)
        format = ['chef-visibility', 'chef-server-visibility'].include?(reporter) ? 'json' : 'json-min'
        output = quiet ? ::File::NULL : $stdout

        Chef::Log.warn "Format is #{format}"
        opts = {
          'report' => true,
          'format' => format,
          'output' => output,
          'logger' => Chef::Log, # Use chef-client log level for inspec run
        }
        opts
      end

      # run profiles and return report
      def call(opts, profiles)
        Chef::Log.info 'Initialize InSpec'
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

      # this is a helper methods to extract the profiles we scan and hand this
      # over to the reporter in addition to the `json-min` report. `json-min`
      # reports do not include information about the source of the profiles
      # TODO: should be available in inspec `json-min` reports out-of-the-box
      # TODO: raise warning when not a compliance-known profile
      def cc_profile_index(profiles)
        cc_profiles = tests_for_runner(profiles).select { |profile| profile[:compliance] }.map { |profile| profile[:compliance] }.uniq.compact
        cc_profiles.map { |profile|
          owner, profile_id = profile.split('/')
          {
            owner: owner,
            profile_id: profile_id,
          }
        }
      end

      # send report to the collector (see libraries/collector_classes.rb)
      def send_report(reporter, server, user, profiles, report)
        Chef::Log.info "Reporting to #{reporter}"

        # Set `insecure` here to avoid passing 6 aruguments to `AuditReport#send_report`
        # See `cookstyle` Metrics/ParameterLists
        insecure = node['audit']['insecure']

        # TODO: harmonize reporter interface
        if reporter == 'chef-visibility'
          Collector::ChefVisibility.new(entity_uuid, run_id, gather_nodeinfo, insecure, report).send_report

        elsif reporter == 'chef-compliance'
          raise_if_unreachable = node['audit']['raise_if_unreachable']
          url = construct_url(server, File.join('/owners', user, 'inspec'))
          if server
            Collector::ChefCompliance.new(url, gather_nodeinfo, raise_if_unreachable, cc_profile_index(profiles), report).send_report
          else
            Chef::Log.warn "'server' and 'token' properties required by inspec report collector #{reporter}. Skipping..."
          end
        elsif reporter == 'chef-server-visibility'
          chef_url = server || base_chef_server_url
          chef_org = Chef::Config[:chef_server_url].split('/').last
          if chef_url
            url = construct_url(chef_url, File.join('organizations', chef_org, 'data-collector'))
            Collector::ChefServerVisibility.new(entity_uuid, run_id, gather_nodeinfo, insecure, report).send_report(url)
          else
            Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
          end
        elsif reporter == 'chef-server-compliance' || reporter == 'chef-server' # chef-server is legacy reporter
          chef_url = server || base_chef_server_url
          chef_org = Chef::Config[:chef_server_url].split('/').last
          if chef_url
            url = construct_url(chef_url + '/compliance/', File.join('organizations', chef_org, 'inspec'))
            Collector::ChefServer.new(url, gather_nodeinfo, raise_if_unreachable, cc_profile_index(profiles), report).send_report
          else
            Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
          end
        elsif reporter == 'json-file'
          timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
          Collector::JsonFile.new(report, timestamp).send_report
        else
          Chef::Log.warn "#{reporter} is not a supported InSpec report collector"
        end
      end
    end
  end
end
