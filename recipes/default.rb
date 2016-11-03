chef_gem 'inspec' do
  version node['audit']['inspec_version'] if node['audit']['inspec_version'] != 'latest'
  compile_time true
  action :install
end

load_inspec_libs
load_audit_handler
