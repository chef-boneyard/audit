# encoding: utf-8
#
# Author:: Stephan Renatus <srenatus@chef.io>
# Copyright (c) 2016, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# inspec gem version to install(e.g. '1.1.0')
default['audit']['inspec_version'] = '1.5.0'

# URI to alternate gem source (e.g. 'http://gems.server.com')
# root of location must host the *specs.4.8.gz source index
default['audit']['inspec_gem_source'] = nil

# Used in cases where the desired install of inspec is via package instead of gem
# Default to false, set to true if needed. Setting to true will skip the inspec recipe and use inspec_package recipe
default['audit']['inspec_package'] = false

# collector possible values: 'chef-server-visibility', 'chef-server-compliance', 'chef-compliance', 'chef-visibility', 'json-file'
# chef-visibility requires inspec version 0.27.1 or above
default['audit']['collector'] = 'chef-server-compliance'

# It will use an InSpec fetcher that fetches compliance profiles via Chef Server
# from Chef Compliance or Chef Automate. Will be activated by default if collector
# 'chef-server-compliance' or 'chef-server-visibility' is used. Possible values: 'chef-server'
default['audit']['fetcher'] = nil

# Attributes server, insecure and token/refresh_token are only needed for the 'chef-compliance' collector
# server format example: 'https://comp-server.example.com/api'
default['audit']['server'] = nil

# choose between the permanent refresh_token or ephemeral token(access_token). Needed only for the 'chef-compliance' collector
default['audit']['refresh_token'] = nil

# the token(access_token) expires in 12h after creation
default['audit']['token'] = nil

# set this insecure attribute to true if the compliance server / chef server uses self-signed ssl certificates
default['audit']['insecure'] = nil

# Chef Compliance organization to post the report to. Defaults to Chef Server org if not defined
# needed for the 'chef-compliance' collector, optional for 'chef-server' and 'chef-server-visibility' collectors
default['audit']['owner'] = nil

# raise exception if Compliance API endpoint is unreachable
# while fetching profiles or posting report
default['audit']['raise_if_unreachable'] = true

# fail converge if downloaded profile is not present
default['audit']['fail_if_not_present'] = false

# by default run audit every time
default['audit']['interval']['enabled'] = false

# by default run compliance once a day
default['audit']['interval']['time'] = 1440

# quiet mode, on by default because this is testing, resources aren't converged in the normal chef sense
default['audit']['quiet'] = true

# overwrite existing profile in upload mode
default['audit']['overwrite'] = true

# use json format since this is for reporting
default['audit']['format'] = 'json'

# set profiles to empty array as default
default['audit']['profiles'] = []
