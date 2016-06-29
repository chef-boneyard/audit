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

inspec_version = node['audit']['inspec_version']

chef_gem 'inspec' do
  version inspec_version if inspec_version != 'latest'
  compile_time true
end

compliance_cache_directory = ::File.join(Chef::Config[:file_cache_path], 'compliance')

directory compliance_cache_directory

handler_directory = ::File.join(Chef::Config[:file_cache_path], 'handler')

directory handler_directory

cookbook_file ::File.join(handler_directory, 'audit_report.rb') do
  source 'audit_report.rb'
end

chef_handler 'Chef::Handler::AuditReport' do
  source "#{handler_directory}/audit_report"
  action :enable
end
