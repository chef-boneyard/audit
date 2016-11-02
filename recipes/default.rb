chef_gem 'inspec' do
  version node['audit']['inspec_version']
  compile_time true
  action :install
end

# load the audit report handler
load_audit_handler
