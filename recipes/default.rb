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

report_collector = node['audit']['collector']

# These attributes should only be set when connecting directly to Chef Compliance, otherwise they should be nil
server = node['audit']['server']
token = node['audit']['token']
# Alternatively, specify a refresh_token and it will be used to retrieve an access token
refresh_token = node['audit']['refresh_token']

interval_seconds = 0 # always run this by default, unless interval is defined
if !node['audit']['interval'].nil? && node['audit']['interval']['enabled']
  interval_seconds = node['audit']['interval']['time'] * 60 # seconds in interval
  Chef::Log.debug "Auditing this machine every #{interval_seconds} seconds "
end

# set the inspec report format based on collector
formatter = report_collector == 'chef-visibility' ? 'json' : 'json-min'

compliance_cache_directory = ::File.join(Chef::Config[:file_cache_path], 'compliance')
directory compliance_cache_directory do
  action :create
end

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

  # file that can be used for interval triggering
  file "#{compliance_cache_directory}/#{p}" do
    action :nothing
  end

  # execute profile
  compliance_profile p do
    owner o
    formatter formatter
    server server
    token token
    refresh_token refresh_token
    insecure node['audit']['insecure'] unless node['audit']['insecure'].nil?
    path path unless path.nil?
    inspec_version node['audit']['inspec_version']
    quiet node['audit']['quiet'] unless node['audit']['quiet'].nil?
    only_if { profile_overdue_to_run?(p, interval_seconds) }
    action [:fetch, :execute]
    notifies :touch, "file[#{compliance_cache_directory}/#{p}]", :immediately
  end
end

# report the results
compliance_report 'chef-server' do
  owner node['audit']['owner']
  server server
  collector report_collector
  token token
  refresh_token refresh_token
  insecure node['audit']['insecure'] unless node['audit']['insecure'].nil?
  quiet node['audit']['quiet'] unless node['audit']['quiet'].nil?
  action :execute
end if node['audit']['profiles'].values.any?
