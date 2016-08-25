# encoding: utf-8
class Audit
  class Resource
    class ChefInspec < Chef::Resource
      resource_name :inspec

      property :version, String, default: 'latest'

      default_action :install

      # installs inspec if required
      action :install do
        converge_by 'install/update inspec' do
          chef_gem 'inspec' do
            version new_resource.version if new_resource.version != 'latest'
            compile_time true
            action :install
          end
        end

        converge_by 'verifies the inspec version' do
          verify_inspec_version version
        end
      end

      def verify_inspec_version(inspec_version)
        require 'inspec'
        # check we have the right inspec version
        if Inspec::VERSION != inspec_version && inspec_version !='latest'
          Chef::Log.warn "Wrong version of inspec (#{Inspec::VERSION}), please "\
            'remove old versions (/opt/chef/embedded/bin/gem uninstall inspec).'
        else
          Chef::Log.warn "Using inspec version: (#{Inspec::VERSION})"
        end
      end
    end
  end
end
