# encoding: utf-8
#
# Cookbook Name:: wrapper_audit
# Recipe:: default

# This includes statement is to include the chef_client_visibility recipe in the
# config_winchefclient cookbook, which is another sample cookbook under the
# examples directory.  The config_winchefclient cookbook provides an example of
# how you would setup chef-client to send converge data to your
# Chef Visibility server.
include_recipe 'config_winchefclient::chef_client_visibility'
# Set the collector to chef-visibility instead of the default chef-server.
node.default['audit']['collector'] = 'chef-visibility'
# Execute the community audit cookbook with the collector set
include_recipe 'audit::default'
