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

default['audit']['server'] = nil
default['audit']['token'] = nil
default['audit']['refresh_token'] = nil
default['audit']['owner'] = nil
default['audit']['quiet'] = nil
default['audit']['profiles'] = {}

# raise exception if Compliance API endpoint is unreachable
# while fetching profiles or posting report
default['audit']['raise_if_unreachable'] = true

# fail converge if downloaded profile is not present
default['audit']['fail_if_not_present'] = false

# fail converge after posting report if any audits have failed
default['audit']['fail_if_any_audits_failed'] = false

# inspec gem version to install(e.g. '0.22.1') or 'latest'
default['audit']['inspec_version'] = '0.22.1'

# by default run audit every time
default['audit']['interval']['enabled'] = false
# by default run compliance once a day
default['audit']['interval']['time'] = 1440

# quiet mode, on by default because this is testing, resources aren't converged in the normal chef sense
default['audit']['quiet'] = true
