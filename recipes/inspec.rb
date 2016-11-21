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

# install inspec from vendored gem in cookbook
# for example:
# gem install —local path/to/gem

# build gem

# pass built gem to chef_gem

if node['audit']['inspec_gem_vendored']
  chef_gem 'inspec' do
    version node['audit']['inspec_version'] if node['audit']['inspec_version'] != 'latest'
    compile_time true
    clear_sources true if node['audit']['inspec_gem_source']
    source File.join(Chef::Config[:file_cache_path], '/cookbooks/audit/files/default/vendor/inspec-1.5.0.gem')
    action :install
  end
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
