require 'chef/handler'
include ReportHelpers

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      def report
        # get reporter(s) from attributes as an array
        reporters = get_reporters(node['audit'])

        if reporters.include?('chef-visibility')
          Chef::Log.warn 'reporter `chef-visibility` is deprecated and removed in audit cookbook 4.0. Please use `chef-automate`.'
        end

        if reporters.include?('chef-server-visibility')
          Chef::Log.warn 'reporter `chef-server-visibility`is deprecated and removed in audit cookbook 4.0. Please use `chef-server-automate`.'
        end

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
        fetcher = node['audit']['fetcher']

        # load inspec, supermarket bundle and compliance bundle
        load_needed_dependencies

        # detect if we run in a chef client with chef server
        load_chef_fetcher if reporters.include?('chef-server') ||
                             reporters.include?('chef-server-compliance') ||
                             reporters.include?('chef-server-visibility') ||
                             reporters.include?('chef-server-automate') ||
                             %w{chef-server chef-server-compliance chef-server-visibility chef-server-automate}.include?(fetcher)

        load_automate_fetcher if fetcher == 'chef-automate'

        # ensure authentication for Chef Compliance is in place, see libraries/compliance.rb
        login_to_compliance(server, user, token, refresh_token) if reporters.include?('chef-compliance')

        # true if profile is due to run (see libraries/helper.rb)
        if check_interval_settings(interval, interval_enabled, interval_time)

          # create a file with a timestamp to calculate interval timing
          create_timestamp_file if interval_enabled

          # return hash of opts to be used by runner
          opts = get_opts('json', quiet)

          # instantiate inspec runner with given options and run profiles; return report
          report = call(opts, profiles)

          # send report to the correct reporter (automate, compliance, chef-server)
          if !report.empty?
            # iterate through reporters
            reporters.each do |reporter|
              send_report(reporter, server, user, profiles, report)
            end
          else
            Chef::Log.error 'Audit report was not generated properly, skipped reporting'
          end
        else
          Chef::Log.info 'Audit run skipped due to interval configuration'
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
        Chef::Log.debug "Load Chef Server fetcher from: #{cookbook_vendor_path}"
        $LOAD_PATH.unshift(cookbook_vendor_path)
        require 'chef-server/fetcher'
      end

      def load_automate_fetcher
        Chef::Log.debug "Load Chef Automate fetcher from: #{cookbook_vendor_path}"
        $LOAD_PATH.unshift(cookbook_vendor_path)
        require 'chef-automate/fetcher'
      end

      # sets format to json-min when chef-compliance, json when chef-automate
      def get_opts(format, quiet)
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
        Chef::Log.info "Initialize InSpec #{::Inspec::VERSION}"
        Chef::Log.debug "Options are set to: #{opts}"
        runner = ::Inspec::Runner.new(opts)

        # parse profile hashes for runner, see libraries/helper.rb
        tests = tests_for_runner(profiles)
        if !tests.empty?
          tests.each { |target| runner.add_target(target, opts) }

          Chef::Log.info "Running tests from: #{tests.inspect}"
          runner.run
          r = runner.report

          # output summary of InSpec Report in Chef Logs
          if !r.nil? && 'json-min' == opts['format']
            time = 0
            time = r[:statistics][:duration] unless r[:statistics].nil?
            passed_controls = r[:controls].select { |c| c[:status] == 'passed' }.size
            failed_controls = r[:controls].select { |c| c[:status] == 'failed' }.size
            skipped_controls = r[:controls].select { |c| c[:status] == 'skipped' }.size
            Chef::Log.info "Summary: #{passed_controls} successful, #{failed_controls} failures, #{skipped_controls} skipped in #{time} s"
          end

          Chef::Log.debug "Audit Report #{r}"
          r
        else
          Chef::Log.warn 'No audit tests are defined.'
          {}
        end
      rescue Inspec::FetcherFailure => e
        Chef::Log.error e.message
        Chef::Log.error "We cannot fetch all profiles: #{tests}. Please make sure you're authenticated and the server is reachable."
        {}
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

      # send InSpec report to the reporter (see libraries/reporters.rb)
      def send_report(reporter, server, user, source_location, report)
        Chef::Log.info "Reporting to #{reporter}"

        # Set `insecure` here to avoid passing 6 aruguments to `AuditReport#send_report`
        # See `cookstyle` Metrics/ParameterLists
        insecure = node['audit']['insecure']

        # TODO: harmonize reporter interface
        if reporter == 'chef-visibility' || reporter == 'chef-automate'
          opts = {
            entity_uuid: run_status.entity_uuid,
            run_id: run_status.run_id,
            node_info: gather_nodeinfo,
            insecure: insecure,
            source_location: source_location,
          }
          Reporter::ChefAutomate.new(opts).send_report(report)
        elsif reporter == 'chef-server-visibility' || reporter == 'chef-server-automate'
          chef_url = server || base_chef_server_url
          chef_org = Chef::Config[:chef_server_url].split('/').last
          if chef_url
            url = construct_url(chef_url, File.join('organizations', chef_org, 'data-collector'))
            opts = {
              entity_uuid: run_status.entity_uuid,
              run_id: run_status.run_id,
              node_info: gather_nodeinfo,
              insecure: insecure,
              url: url,
              source_location: source_location,
            }
            Reporter::ChefServerAutomate.new(opts).send_report(report)
          else
            Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
          end
        elsif reporter == 'chef-compliance'
          if server
            raise_if_unreachable = node['audit']['raise_if_unreachable']
            url = construct_url(server, File.join('/owners', user, 'inspec'))

            config = Compliance::Configuration.new
            token = config['token']

            opts = {
              url: url,
              node_info: gather_nodeinfo,
              raise_if_unreachable: raise_if_unreachable,
              token: token,
              source_location: source_location,
            }
            Reporter::ChefCompliance.new(opts).send_report(report)
          else
            Chef::Log.warn "'server' and 'token' properties required by inspec report collector #{reporter}. Skipping..."
          end
        elsif reporter == 'chef-server-compliance' || reporter == 'chef-server'
          chef_url = server || base_chef_server_url
          chef_org = Chef::Config[:chef_server_url].split('/').last
          if chef_url
            url = construct_url(chef_url + '/compliance/', File.join('organizations', chef_org, 'inspec'))
            opts = {
              url: url,
              node_info: gather_nodeinfo,
              raise_if_unreachable: raise_if_unreachable,
              source_location: source_location,
            }
            Reporter::ChefServer.new(opts).send_report(report)
          else
            Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
          end
        elsif reporter == 'json-file'
          timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
          filename = 'inspec' << '-' << timestamp << '.json'
          path = File.expand_path("../../../../#{filename}", __FILE__)
          Chef::Log.info "Writing report to #{path}"
          Reporter::JsonFile.new({ file: path }).send_report(report)
        else
          Chef::Log.warn "#{reporter} is not a supported InSpec report collector"
        end
      end
    end
  end
end
