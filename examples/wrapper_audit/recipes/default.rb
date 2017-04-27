# encoding: utf-8
#
# Cookbook Name:: wrapper_audit
# Recipe:: default

# This includes statement is to include the chef_client_config recipe in the
# automate_win cookbook, which is another sample cookbook under the
# examples directory.  The automate_win cookbook provides an example of
# how you would setup chef-client to send converge data to your
# Chef Automate server.
include_recipe 'automate_win::chef_client_config'

# Set the collector to chef-automate instead of the default chef-server-compliance.
node.default['audit']['collector'] = 'chef-automate'

# Execute the community audit cookbook with the collector set
include_recipe 'audit::default'
