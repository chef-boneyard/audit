chef_gem 'inspec-core' do
  action :nothing
end.run_action(:remove)

chef_gem 'inspec' do
  version '1.19.1'
  action :nothing
end.run_action(:install)
