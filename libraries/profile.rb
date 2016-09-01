# encoding: utf-8
require 'tempfile'
require 'uri'
require 'net/https'
require 'fileutils'

# `compliance_profile` custom resource to collect and run Chef Compliance
# profiles
class Audit
  class Resource
    class ComplianceProfile < Chef::Resource
      include ComplianceHelpers
      use_automatic_resource_name

      property :profile, String, name_property: true
      property :owner, String, required: true

      # to use a chef-compliance server that is used with chef-server integration
      property :server, [String, URI, nil]
      property :port, Integer
      property :token, [String, nil]
      property :insecure, [TrueClass, FalseClass], default: false
      property :formatter, ['json', 'json-min'], default: 'json-min'
      property :quiet, [TrueClass, FalseClass], default: true
      # TODO(sr) it might be nice to default to settings from attributes

      # alternative to (owner, profile)-addressing for profiles,
      # e.g. for running profiles from disk (coming from some other source)
      property :path, String

      default_action :execute

      action :fetch do
        converge_by 'load required inspec modules' do
          require 'inspec'
          # load the supermarket plugin
          require 'bundles/inspec-supermarket/api'
          require 'bundles/inspec-supermarket/target'

          # load the compliance api plugin
          require 'bundles/inspec-compliance/api'
          require 'bundles/inspec-compliance/http'
        end

        converge_by 'create cache directory' do
          directory(::File.join(Chef::Config[:file_cache_path], 'compliance')).run_action(:create)
        end

        converge_by 'fetch compliance profile' do
          return if path # will be fetched from other source during execute phase

          o, p = normalize_owner_profile
          Chef::Log.info "Fetch compliance profile #{o}/#{p}"

          path = tar_path
          access_token = token

          if access_token # go direct
            reqpath ="owners/#{o}/compliance/#{p}/tar"
            url = construct_url(server, reqpath)
            Chef::Log.info "Load profile from: #{url}"

            tf = Tempfile.new('foo', Dir.tmpdir, binmode: true)

            opts = { use_ssl: url.scheme == 'https',
                     verify_mode: OpenSSL::SSL::VERIFY_NONE, # FIXME
            }
            Net::HTTP.start(url.host, url.port, opts) do |http|
              resp = with_http_rescue do
                http.get(url.path, 'Authorization' => "Bearer #{access_token}")
              end
              tf.write(resp.body)
            end
            tf.flush
          else # go through Chef::ServerAPI
            reqpath ="organizations/#{org}/owners/#{o}/compliance/#{p}/tar"
            url = construct_url(base_chef_server_url + '/compliance/', reqpath)
            Chef::Log.info "Load profile from: #{url}"

            Chef::Config[:verify_api_cert] = false # FIXME
            Chef::Config[:ssl_verify_mode] = :verify_none # FIXME

            rest = Chef::ServerAPI.new(url, Chef::Config)
            tf = with_http_rescue do
              rest.binmode_streaming_request(url)
            end
          end

          case node['platform']
          when 'windows'
            # mv replaced due to Errno::EACCES:
            # https://bugs.ruby-lang.org/issues/10865
            FileUtils.cp(tf.path, path) unless tf.nil?
          else
            FileUtils.mv(tf.path, path) unless tf.nil?
          end

        end
      end

      action :execute do
        # ensure it's there, if if the profile wasn't fetched using these resources
        converge_by 'load required inspec modules' do
          require 'inspec'
        end

        converge_by 'create/verify cache directory' do
          directory(::File.join(Chef::Config[:file_cache_path], 'compliance')).run_action(:create)
        end

        converge_by 'execute compliance profile' do
          path ||= tar_path
          report_file = report_path

          supported_schemes = %w{http https supermarket compliance chefserver}
          if !supported_schemes.include?(URI(path).scheme) && !::File.exist?(path)
            Chef::Log.warn "No such path! Skipping: #{path}"
            raise "Aborting since profile is not present here: #{path}" if run_context.node['audit']['fail_if_not_present']
            return
          end

          Chef::Log.info "Executing: #{path}"

          # TODO: flesh out inspec's report CLI interface,
          #       make this an execute[inspec check ...]
          output = quiet ? ::File::NULL : $stdout
          runner = ::Inspec::Runner.new('report' => true, 'format' => formatter, 'output' => output)
          runner.add_target(path, {})
          begin
            runner.run
          # TODO: weird exception, do we need that handling?
          rescue Chef::Exceptions::ValidationFailed => e
            Chef::Log.error e
          end

          file report_file do
            content runner.report.to_json
            sensitive true
            backup false
          end
        end
      end

      def normalize_owner_profile
        if profile.include?('/')
          profile.split('/').last(2)
        else
          [owner || 'base', profile]
        end
      end

      def tar_path
        return path if path
        o, p = normalize_owner_profile
        case node['platform']
        when 'windows'
          windows_path = Chef::Config[:file_cache_path].tr('\\', '/')
          ::File.join(windows_path, 'compliance', "#{o}_#{p}.tgz")
        else
          ::File.join(Chef::Config[:file_cache_path], 'compliance', "#{o}_#{p}.tgz")
        end
      end

      def report_path
        o, p = normalize_owner_profile
        case node['platform']
        when 'windows'
          windows_path = Chef::Config[:file_cache_path].tr('\\', '/')
          ::File.join(windows_path, 'compliance', "#{o}_#{p}_report.json")
        else
          ::File.join(Chef::Config[:file_cache_path], 'compliance', "#{o}_#{p}_report.json")
        end
      end

      def org
        Chef::Config[:chef_server_url].split('/').last
      end
    end
  end
end
