# encoding: utf-8
#
# Cookbook Name:: audit
# Recipe:: inspec
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

# if the user has opted to install via package, we go this route
if node['audit']['inspec_package']['source']
  if node['audit']['inspec_package']['libpath'].nil?
    raise 'Must specify node[\'audit\'][\'inspec_package\'][\'libpath\'] attributes'
  end

  package_path = File.join(Chef::Config[:file_cache_path], File.basename(node['audit']['inspec_package']['source']))

  # Ensure file exists at compile time
  remote_file package_path do
    source node['audit']['inspec_package']['source']
    action :nothing
  end.run_action(:create)

  # Do package install at compile time to allow load_inspec_libs to function
  # as intended

  # Determine os to decide which chef package resource to use.  This is normally
  # auto-detected by the chef-package resource, but when the source is specified,
  # this functionality does not exist...so we're doing it manually. The default is apt.

  case node['platform']
  when 'ubuntu'
    dpkg_package 'inspec' do
      source package_path
      action :nothing
    end.run_action(:install)
  else
    package 'inspec' do
      source package_path
      action :nothing
    end.run_action(:install)
  end

  libpath = node['audit']['inspec_package']['libpath']
  $LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)

# otherwise, we stick to the default and install via gem
else
  chef_gem 'inspec' do
    version node['audit']['inspec_version'] if node['audit']['inspec_version'] != 'latest'
    compile_time true
    clear_sources true if node['audit']['inspec_gem_source']
    source node['audit']['inspec_gem_source'] if node['audit']['inspec_gem_source']
    action :install
  end
end

load_inspec_libs
