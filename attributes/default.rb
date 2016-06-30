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
#

# Compliance server if you want to report directly to it
default['audit']['server'] = nil
# Compliance token for accessing compliance, used only when reporting directly to compliance
default['audit']['token'] = nil
# Compliance refresh token, used when reporting directly to the compliance server
default['audit']['refresh_token'] = nil
# The owner of the scanned node when reporting directly to the compliance server
default['audit']['owner'] = nil
# Whether to silence report results
default['audit']['quiet'] = false
# The profiles to scan
default['audit']['profiles'] = {}

# inspec gem version to install(e.g. '0.22.1') or 'latest'
default['audit']['inspec_version'] = '0.22.1'

# by default run audit every time
default['audit']['interval']['enabled'] = false
# by default run compliance once a day
default['audit']['interval']['time'] = 1440
