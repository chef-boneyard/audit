chef_gem 'inspec' do
  version node['audit']['inspec_version'] if node['audit']['inspec_version'] != 'latest'
  compile_time true
  clear_sources true if node['audit']['inspec_gem_source']
  source node['audit']['inspec_gem_source'] if node['audit']['inspec_gem_source']
  action :install
end

load_inspec_libs
load_audit_handler
