# encoding: utf-8
#
# Cookbook Name:: compliance
# Recipe:: default
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

token = node['audit']['token']
server = node['audit']['server']

# iterate over all selected profiles
node['audit']['profiles'].each do |owner_profile, value|
  case value
  when Hash
    next if value['disabled']
    path = value['source']
  else
    next if value == false
  end
  fail "Invalid profile name '#{owner_profile}'. "\
       "Must contain /, e.g. 'john/ssh'" if owner_profile !~ %r{\/}
  o, p = owner_profile.split('/').last(2)

  compliance_profile p do
    owner o
    server server
    token token
    path path unless path.nil?
    inspec_version node['audit']['inspec_version']
    quiet node['audit']['quiet'] unless node['audit']['quiet'].nil?
    action [:fetch, :execute]
  end
end

# report the results
compliance_report 'chef-server' do
  owner node['audit']['owner']
  server server
  token token
  variant node['audit']['variant']
  quiet node['audit']['quiet'] unless node['audit']['quiet'].nil?
  action :execute
end if node['audit']['profiles'].values.any?
