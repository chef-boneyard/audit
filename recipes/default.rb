include_recipe 'chef_handler'

handler_directory = ::File.join(Chef::Config[:file_cache_path], 'handler')

directory handler_directory do
  action :create
end

cookbook_file ::File.join(handler_directory, 'audit_report.rb') do
  source 'audit_report.rb'
end

chef_handler 'Chef::Handler::AuditReport' do
  source "#{handler_directory}/audit_report.rb"
  supports :report => true
  action :enable
end

chef_inspec 'inspec' do
  action :install
end
