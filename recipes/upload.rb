# encoding: utf-8
#
# Cookbook Name:: audit
# Recipe:: upload
#
# Copyright 2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ensure inspec is available
include_recipe 'audit::_inspec'

# These attributes should only be set when connecting directly to Chef Compliance, otherwise they should be nil
server = node['audit']['server']

# only needed when fetching / reporting directly to Compliance Server
compliance_token 'Compliance Token' do
  server server
  token node['audit']['refresh_token'] || node['audit']['token']
  insecure node['audit']['insecure']
end unless server.nil?

# iterate over all selected profiles and upload them
node['audit']['profiles'].each do |owner_profile, value|
  case value
  when Hash
    next if value['disabled']
    path = value['source']
  else
    next if value == false
  end
  raise "Invalid profile name '#{owner_profile}'. "\
       "Must contain /, e.g. 'john/ssh'" if owner_profile !~ %r{\/}
  o, p = owner_profile.split('/').last(2)

  # upload profile
  compliance_profile p do
    owner o
    server server
    path path
    insecure node['audit']['insecure']
    action :upload
  end
end
