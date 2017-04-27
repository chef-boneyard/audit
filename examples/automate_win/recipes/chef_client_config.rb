# encoding: utf-8
#
# Cookbook Name:: automate_win
# Recipe:: chef_client_config

# Create client.d directory in the chef client folder
directory 'c:/chef/client.d/' do
  recursive true
  action :create
end

# Create the automate_ingest file in the client.d directory which will send
# 'chef-client' data to Chef Automate
template 'c:/chef/client.d/automate_ingest.rb' do
  source 'automate_ingest.rb.erb'
  variables(
    server_url: 'https://automateserver.domain.com/data-collector/v0/',
    auth_token: 'some#databag#value',
  )
  notifies :create, 'ruby_block[reload_client_config]'
  action :create
end

include_recipe 'chef-client::config'
