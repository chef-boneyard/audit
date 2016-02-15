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

compliance_profile 'linux' do
  owner 'base'
  # server URI.parse('http://192.168.33.1:2134')
  # token 'foo' # NOTE(sr) currently ignored

  # NB cannot try "no server parameter => use chefserver" with TK
  server URI.parse('https://chef.compliance.test/compliance/')
  action [:fetch, :execute]
end

compliance_report 'chef-server' do
  server URI.parse('https://chef.compliance.test/compliance/')
end
