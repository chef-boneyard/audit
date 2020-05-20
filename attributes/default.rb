# encoding: utf-8
#
# Author:: Stephan Renatus <srenatus@chef.io>
# Copyright:: (c) 2016-2019, Chef Software Inc. <legal@chef.io>
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

# Controls the inspec gem version to install and execution. Example values: '1.1.0', 'latest'
# Starting with Chef Infra Client 15, only the embedded InSpec gem can be used and this attribute will be ignored
default['audit']['inspec_version'] = nil

# sets URI to alternate gem source
# example values: nil, 'https://mygem.server.com'
# notes: the root of the URL must host the *specs.4.8.gz source index
default['audit']['inspec_gem_source'] = nil

# If enabled, a cache is built for all backend calls. This should only be
# disabled if you are expecting unique results from the same backend call.
default['audit']['inspec_backend_cache'] = true

# controls where inspec scan reports are sent
# possible values: 'chef-server-automate', 'chef-automate', 'json-file'
# notes: 'chef-automate' requires inspec version 0.27.1 or greater
# deprecated: 'chef-visibility' is replaced with 'chef-automate'
# deprecated: 'chef-compliance' is replaced with 'chef-automate'
# deprecated: 'chef-server-visibility' is replaced with 'chef-server-automate'
default['audit']['reporter'] = 'json-file'

# controls where inspec profiles are fetched from, Chef Automate or via Chef Server
# possible values: nil, 'chef-server', 'chef-automate'
default['audit']['fetcher'] = nil

# allow for connections to HTTPS endpoints using self-signed ssl certificates
default['audit']['insecure'] = nil

# Optional for 'chef-server-automate' reporter
# defaults to Chef Server org if not defined
default['audit']['owner'] = nil

# raise exception if Automate API endpoint is unreachable
# while fetching profiles or posting a report
default['audit']['raise_if_unreachable'] = true

# fail converge if downloaded profile is not present
# https://github.com/chef-cookbooks/audit/issues/166
default['audit']['fail_if_not_present'] = false

# control how often inspec scans are run, if not on every node converge
# notes: false value will result in running inspec scan every converge
default['audit']['interval']['enabled'] = false

# controls how often inspec scans are run (in minutes)
# notes: only used if interval is enabled above
default['audit']['interval']['time'] = 1440

# controls verbosity of inspec runner
default['audit']['quiet'] = true

# Chef Inspec Compliance profiles to be used for scan of node
# See README.md for details
default['audit']['profiles'] = {}

# Attributes used to run the given profiles
default['audit']['attributes'] = {}

# Set this to false if you don't want ['audit']['attributes'] to be saved in the node object and stored in Chef Server or Automate. Useful if you are passing sensitive data to the inspec profile via the attributes.
default['audit']['attributes_save'] = true

# If enabled, a hash of the Chef "node" object will be sent to InSpec in an attribute
# named `chef_node`
default['audit']['chef_node_attribute_enabled'] = false

# Set this to the path of a YAML waiver file you wish to apply
# See https://www.inspec.io/docs/reference/waivers/
default['audit']['waiver_file'] = nil

# The location of the json-file output:
# <chef_cache_path>/cookbooks/audit/inspec-<YYYYMMDDHHMMSS>.json
default['audit']['json_file']['location'] =
  File.expand_path(Time.now.utc.strftime('../../inspec-%Y%m%d%H%M%S.json'), __FILE__)

# Control results that have a `run_time` below this limit will
# be stripped of the `start_time` and `run_time` fields to
# reduce the size of the reports being sent to Automate
default['audit']['run_time_limit'] = 1.0

# A control result message that exceeds this character limit will be truncated.
# This helps keep reports to a reasonable size. On rare occasions, we've seen messages exceeding 9 MB in size,
# causing the report to not be ingested in the backend because of the 4 MB report size rpc limitation.
# InSpec will append this text at the end of any truncated messages: `[Truncated to 10000 characters]`
# Requires InSpec 4.18.114 or newer (bundled with Chef Infra Client starting with version 16.0.303)
default['audit']['result_message_limit'] = 10000

# When an InSpec resource throws an exception (e.g. permission denied), results will contain a short error message and a
# detailed ruby stacktrace of the error. This attribute instructs InSpec not to include the detailed stacktrace in order
# to keep the overall report to a manageable size.
# Requires InSpec 4.18.114 or newer (bundled with Chef Infra Client starting with version 16.0.303)
default['audit']['result_include_backtrace'] = false

# The array of results per control will be truncated at this limit to avoid large reports that cannot be
# processed by Automate. A summary of removed results will be sent with each impacted control.
default['audit']['control_results_limit'] = 50
