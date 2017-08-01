#
# Cookbook Name:: test_helper
# Recipe:: setup
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# needed to fetch github profiles
include_recipe 'git::default'

# needed for testing inspec version installed
output=Chef::JSONCompat.to_json_pretty(node.to_hash).to_s
file '/tmp/node.json' do
  content output
  sensitive true
end
