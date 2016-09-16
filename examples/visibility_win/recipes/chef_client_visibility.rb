# encoding: utf-8
#
# Cookbook Name:: config_winchefclient
# Recipe:: default

# Create client.d directory in the chef client folder
directory 'c:/chef/client.d/' do
  recursive true
end

# Create the visibility_ingest file in the client.d directory which will send
# 'chef-client' data to Visibility

cookbook_file 'c:/chef/client.d/visibility_ingest.rb' do
  source 'visibility_ingest.rb'
  notifies :create, 'ruby_block[reload_client_config]'
end

include_recipe 'chef-client::config'
