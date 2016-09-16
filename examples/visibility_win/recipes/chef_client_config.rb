# encoding: utf-8
#
# Cookbook Name:: visibility_win
# Recipe:: chef_client_config

# Create client.d directory in the chef client folder
directory 'c:/chef/client.d/' do
  recursive true
  action :create
end

# Create the visibility_ingest file in the client.d directory which will send
# 'chef-client' data to Visibility
template 'c:/chef/client.d/visibility_ingest.rb' do
  source 'visibility_ingest.rb.erb'
  variables(
    server_url: 'https://automateserver.domain.com/data-collector/v0/',
    auth_token: 'some#databag#value',
  )
  notifies :create, 'ruby_block[reload_client_config]'
  action :create
end

include_recipe 'chef-client::config'
