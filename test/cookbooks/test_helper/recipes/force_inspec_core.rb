chef_gem 'inspec-core' do
  action :nothing
end.run_action(:remove)

chef_gem 'inspec-core-bin' do
  action :nothing
end.run_action(:remove)

chef_gem 'inspec' do
  action :nothing
end.run_action(:remove)

chef_gem 'inspec-core' do
  version '4.3.2'
  action :nothing
end.run_action(:install)
