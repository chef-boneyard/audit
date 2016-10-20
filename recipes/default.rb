include_recipe 'chef_handler'

# install inspec if require
inspec 'inspec' do
  version node['audit']['inspec_version']
  action :install
end

# run chef handler
handler_directory = ::File.join(Chef::Config[:file_cache_path], 'handler')
directory handler_directory do
  action :create
end

cookbook_file ::File.join(handler_directory, 'audit_report.rb') do
  source 'audit_report.rb'
end

chef_handler 'Chef::Handler::AuditReport' do
  source "#{handler_directory}/audit_report.rb"
  action :enable
end
