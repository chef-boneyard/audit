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
inspec 'inspec' do
  version node['audit']['inspec_version']
  action :install
end

# These attributes should only be set when connecting directly to Chef Compliance, otherwise they should be nil
server = node['audit']['server']

# iterate over all selected profiles and upload them
node['audit']['profiles'].each do |profile|
  profile_owner = profile[:name]
  profile_path = profile[:path]
  raise "Invalid profile name '#{profile_owner}'. "\
       "Must contain /, e.g. 'john/ssh'" if profile_owner !~ %r{\/}
  _o, p = profile_owner.split('/').last(2)
  raise "Invalid path '#{profile_path}'" if profile_path.nil?

  # upload profile
  inspec p do
    profile_name p
    owner node['audit']['owner']
    server server
    path profile[:path]
    insecure node['audit']['insecure']
    overwrite node['audit']['overwrite']
    refresh_token node['audit']['refresh_token']
    action :upload
  end
end
