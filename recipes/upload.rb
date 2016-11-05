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

include_recipe 'audit::inspec'

# iterate over all selected profiles and upload them
node['audit']['profiles'].each do |profile|
  profile_owner = profile[:name]
  profile_path = profile[:path]
  Chef::Log.error "Invalid profile name '#{profile_owner}'. "\
       "Must contain /, e.g. 'john/ssh'" if profile_owner !~ %r{\/}
  _o, p = profile_owner.split('/').last(2)
  Chef::Log.error "Invalid path '#{profile_path}'" if profile_path.nil?

  # upload profile
  compliance_upload p do
    profile_name p
    owner node['audit']['owner']
    server node['audit']['server']
    path profile[:path]
    insecure node['audit']['insecure']
    overwrite node['audit']['overwrite']
    refresh_token node['audit']['refresh_token']
    action :upload
  end
end
