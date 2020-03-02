chef_gem 'inspec-core' do
  compile_time true
  action :remove
end

chef_gem 'inspec-core-bin' do
  compile_time true
  action :remove
end

chef_gem 'inspec' do
  compile_time true
  action :remove
end

chef_gem 'inspec' do
  compile_time true
  version '1.19.1'
  action :install
end
