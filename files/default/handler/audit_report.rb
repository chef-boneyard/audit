require 'chef/handler'
include ReportHelpers

class Chef
  class Handler
    # Creates a compliance audit report
    class AuditReport < ::Chef::Handler
      MIN_INSPEC_VERSION = '1.25.1'.freeze
      MIN_INSPEC_VERSION_AUTOMATE_REPORTER = '2.2.64'.freeze

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
        if node['audit']['profiles'].class.eql?(Chef::Node::ImmutableMash)
          profiles = []
          node['audit']['profiles'].keys.each do |p|
            h = node['audit']['profiles'][p].to_hash
            h['name'] = p
            profiles.push(h)
          end
        else
          Chef::Log.warn "Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes."
          profiles = node['audit']['profiles']
        end
        quiet = node['audit']['quiet']
        fetcher = node['audit']['fetcher']
        attributes = node['audit']['attributes'].to_h

        # add chef node data as an attribute if enabled
        attributes['chef_node'] = chef_node_attribute_data if node['audit']['chef_node_attribute_enabled']

        # load inspec, supermarket bundle and compliance bundle
        load_needed_dependencies

        # confirm our inspec version is valid
        validate_inspec_version

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
          reporter_format = 'json'
          if Gem::Version.new(::Inspec::VERSION) >= Gem::Version.new(MIN_INSPEC_VERSION_AUTOMATE_REPORTER)
            reporter_format = 'json-automate'
          end

          # return hash of opts to be used by runner
          opts = get_opts(reporter_format, quiet, attributes)

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

      def validate_inspec_version
        minimum_ver_msg = "This audit cookbook version requires InSpec #{MIN_INSPEC_VERSION} or newer, aborting compliance scan..."
        raise minimum_ver_msg if Gem::Version.new(::Inspec::VERSION) < Gem::Version.new(MIN_INSPEC_VERSION)

        # check if we have a valid version for backend caching
        backend_cache_msg = 'inspec_backend_cache requires InSpec version >= 1.47.0'
        Chef::Log.warn backend_cache_msg if node['audit']['inspec_backend_cache'] &&
                                            (Gem::Version.new(::Inspec::VERSION) < Gem::Version.new('1.47.0'))
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

      def get_opts(reporter, quiet, attributes)
        output = quiet ? ::File::NULL : $stdout
        Chef::Log.debug "Reporter is [#{reporter}]"
        opts = {
          'report' => true,
          'format' => reporter, # For compatibility with older versions of inspec. TODO: Remove this line from Q2 2019
          'reporter' => [reporter],
          'output' => output,
          'logger' => Chef::Log, # Use chef-client log level for inspec run,
          backend_cache: node['audit']['inspec_backend_cache'],
          attributes: attributes,
        }
        opts
      end

      # run profiles and return report
      def call(opts, profiles)
        Chef::Log.info "Using InSpec #{::Inspec::VERSION}"
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
          if !r.nil? && opts['format'] == 'json-min'
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
        runlist_roles = n.run_list.select { |item| item.type == :role }.map(&:name)
        runlist_recipes = n.run_list.select { |item| item.type == :recipe }.map(&:name)
        {
          node: n.name,
          os: {
            release: n['platform_version'],
            family: n['platform'],
          },
          environment: n.environment,
          roles: runlist_roles,
          recipes: runlist_recipes,
          policy_name: n.policy_name || '',
          policy_group: n.policy_group || '',
          chef_tags: n.tags,
          organization_name: chef_server_uri.path.split('/').last || '',
          source_fqdn: chef_server_uri.host || '',
          ipaddress: n['ipaddress'],
          fqdn: n['fqdn'],
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
          # `run_status.entity_uuid` is calling the `entity_uuid` method in libraries/helper.rb
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
            # `run_status.entity_uuid` is calling the `entity_uuid` method in libraries/helper.rb
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
            Reporter::ChefServerCompliance.new(opts).send_report(report)
          else
            Chef::Log.warn "unable to determine chef-server url required by inspec report collector '#{reporter}'. Skipping..."
          end
        elsif reporter == 'json-file'
          path = node['audit']['json_file']['location']
          Chef::Log.info "Writing report to #{path}"
          Reporter::JsonFile.new(file: path).send_report(report)
        else
          Chef::Log.warn "#{reporter} is not a supported InSpec report collector"
        end
      end

      # Gather Chef node attributes, etc. for passing to the InSpec run
      def chef_node_attribute_data
        node_data = node.to_h
        node_data['chef_environment'] = node.chef_environment

        node_data
      end
    end
  end
end
