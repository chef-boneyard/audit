# encoding: utf-8
#
# Cookbook:: audit
# Recipe:: default
#
# Copyright:: 2016-2019 Chef Software, Inc.
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

# The "audit cookbook" and Chef's own "Audit Mode" are not compatible
# due to global state management done by RSpec which is used by both
# implementations. To prevent unexpected results, the audit cookbook
# will prevent Chef from continuing if Audit Mode is not disabled.
unless Chef::Config[:audit_mode] == :disabled || Gem::Requirement.new('>= 15').satisfied_by?(Gem::Version.new(Chef::VERSION))
  raise 'Audit Mode is enabled. The audit cookbook and Audit Mode' \
    ' cannot be used at the same time. Please disable Audit Mode' \
    ' in your client configuration.'
end

include_recipe 'audit::inspec'

# Call helper methods located in libraries/helper.rb
copy_audit_attributes
load_audit_handler
