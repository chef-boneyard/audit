# encoding: utf-8

# `compliance_token` custom resource to communicate with Chef Compliance
class Audit
  class Resource
    class ComplianceToken < Chef::Resource
      include ComplianceHelpers
      use_automatic_resource_name

      property :server, [String, URI, nil], required: true
      property :port, Integer
      property :token, [String, nil], required: true
      property :insecure, [TrueClass, FalseClass], default: false

      default_action :create

      action :create do
        converge_by 'compliance server auth token setup' do
          # stash token in node.run_state to pass between resources
          node.run_state['compliance'] ||= {}
          if node['audit']['refresh_token']
            Chef::Log.info 'Using refresh_token to exchange for an access token.'
            node.run_state['compliance']['access_token'] = retrieve_access_token(server, token, insecure)
          else
            Chef::Log.info 'Using token attribute. This token is short lived and will expire.'
            node.run_state['compliance']['access_token'] = token
          end
        end
      end
    end
  end
end
