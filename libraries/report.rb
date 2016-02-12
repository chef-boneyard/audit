# `compliance_report` custom resource to run Chef Compliance profiles and 
# send reports to Chef Compliance
class ComplianceReport < Chef::Resource
  use_automatic_resource_name

  property :name, String, name_property: true

  # to use a chef-compliance server that is _not_ "colocated" with chef-server
  property :server, String
  property :username, String
  property :password, String

  # to override the node this report is reported for
  property :node, String #, default: node.name
  property :environment, String #, default: node.environment

  # who owns the node?
  # maybe only required for on-the-fly added nodes?
  property :node_owner, String

  default_action :execute

  action :execute do
    converge_by 'Execute fetched Chef Compliance profiles' do
      ruby_block 'execute profiles' do
        block do
          rest = Chef::ServerAPI.new(Chef::Config[:chef_server_url])
          puts run_context.resource_collection.inspect
        end
      end
    end
  end
end
