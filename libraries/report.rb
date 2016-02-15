# `compliance_report` custom resource to run Chef Compliance profiles and 
# send reports to Chef Compliance
class ComplianceReport < Chef::Resource
  include ComplianceHelpers
  use_automatic_resource_name

  property :name, String, name_property: true

  # to use a chef-compliance server that is _not_ "colocated" with chef-server
  property :server, URI
  property :port, Integer
  property :username, String
  property :password, String
  property :token, String

  # to override the node this report is reported for
  property :node, String #, default: node.name
  property :environment, String #, default: node.environment

  # who owns the node?
  # maybe only required for on-the-fly added nodes?
  property :node_owner, String, required: true

  default_action :execute

  action :execute do
    converge_by "report compliance profiles' results" do
      reports, ownermap = compound_report(profiles)

      blob = get_node
      blob[:reports] = reports
      blob[:profiles] = ownermap

      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none

      url = construct_url(::File.join("/owners", node_owner.to_s, "inspec"))
      puts "url: #{url}"
      rest = Chef::ServerAPI.new(url, Chef::Config)
      rest.post(url, blob)
    end
  end

  # filters resource collection
  def profiles
    run_context.resource_collection.select do |r|
      r.is_a?(ComplianceProfile)
    end
  end

  def compound_report(*profiles)
    report = {}
    ownermap = {}

    profiles.each do |prof|
      o, p = prof.first.normalize_owner_profile # XXX why .first?
      report[p] = ::JSON.parse(::File.read(prof.first.get_report))
      ownermap[o] = p
    end

    [report, ownermap]
  end

  def get_node
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
end
