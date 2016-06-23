# encoding: utf-8
# `compliance_report` custom resource to run Chef Compliance profiles and
# send reports to Chef Compliance
class ComplianceReport < Chef::Resource
  include ComplianceHelpers
  use_automatic_resource_name

  property :name, String, name_property: true

  # to use a chef-compliance server that is used with chef-server integration
  property :server, [String, URI, nil]
  property :port, Integer
  property :token, [String, nil]
  property :refresh_token, [String, nil]
  property :quiet, [TrueClass, FalseClass], default: true

  property :environment, String # default: node.environment
  property :owner, [String, nil]

  default_action :execute

  action :execute do
    converge_by "report compliance profiles' results" do
      reports, ownermap = compound_report(profiles)

      blob = node_info
      blob[:reports] = reports
      total_failed = 0
      blob[:reports].each do |k, _|
        Chef::Log.info "Summary for #{k} #{blob[:reports][k]['summary'].to_json}" if quiet
        total_failed += blob[:reports][k]['summary']['failure_count'].to_i
      end
      blob[:profiles] = ownermap

      # resolve owner
      o = return_or_guess_owner

      # retrieve access token if a refresh token is set
      access_token = token
      access_token = retrieve_access_token unless refresh_token.nil?

      if access_token # go direct
        url = construct_url(server, ::File.join('/owners', o, 'inspec'))
        req = Net::HTTP::Post.new(url, { 'Authorization' => "Bearer #{token}" })
        req.body = blob.to_json
        Chef::Log.info "Report to: #{url}"

        opts = { use_ssl: url.scheme == 'https',
                 verify_mode: OpenSSL::SSL::VERIFY_NONE, # FIXME
        }
        Net::HTTP.start(url.host, url.port, opts) do |http|
          with_http_rescue do
            http.request(req)
          end
        end
      else # go through Chef::ServerAPI
        Chef::Config[:verify_api_cert] = false
        Chef::Config[:ssl_verify_mode] = :verify_none

        url = construct_url(base_chef_server_url + '/compliance/', ::File.join('organizations', o, 'inspec'))
        Chef::Log.info "Report to: #{url}"

        rest = Chef::ServerAPI.new(url, Chef::Config)
        with_http_rescue do
          rest.post(url, blob)
        end
      end
      fail "#{total_failed} audits have failed.  Aborting chef-client run." if total_failed > 0 && node['audit']['fail_if_any_audits_failed']
    end
  end

  # filters resource collection
  def profiles
    run_context.resource_collection.select do |r|
      r.is_a?(ComplianceProfile)
    end.flatten
  end

  def compound_report(*profiles)
    report = {}
    ownermap = {}

    profiles.flatten.each do |prof|
      next unless ::File.exist?(prof.report_path)
      o, p = prof.normalize_owner_profile
      report[p] = ::JSON.parse(::File.read(prof.report_path))
      ownermap[p] = o
    end

    [report, ownermap]
  end

  def node_info
    n = run_context.node
    {
      node: n.name,
      os: {
        # arch: os[:arch],
        release: n['platform_version'],
        family: n['platform'],
      },
      environment: environment || n.environment,
    }
  end

  def return_or_guess_owner
    owner || Chef::Config[:chef_server_url].split('/').last
  end
end
