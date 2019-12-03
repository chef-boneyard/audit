# audit cookbook
[![Cookbook Version](http://img.shields.io/cookbook/v/audit.svg)][cookbook] [![Build Status](http://img.shields.io/travis/chef-cookbooks/audit.svg)][travis]

The `audit` cookbook allows you to run InSpec profiles as part of a Chef Client run. It downloads configured profiles from various sources like Chef Automate, Chef Supermarket or Git and reports audit runs to Chef Automate.

## Quickstart

The `audit` cookbook supports a number of different reporters and fetchers which can be confusing. Please see the [supported configurations documentation](https://github.com/chef-cookbooks/audit/blob/master/docs/supported_configuration.md) which has a few copy/paste examples to get you started quickly.

## Requirements

### Chef

- Chef Client >=12.20

### Support Matrix

#### Chef Automate

| Automate version   | InSpec version   | Audit Cookbook version   |
|--------------------|------------------|--------------------------|
|   < 0.8.0          |   ≤ 1.23.0       |   ≤ 3.1.0                |
|   ≥ 0.8.0          |   ≥ 1.24.0       |   ≥ 4.0.0                |
|   ≥ 2              |   ≥ 2.2.102      |   ≥ 7.1.0                |

#### Chef Infra Client

| Chef Client                | Audit Cookbook version    |
|----------------------------|---------------------------|
|   >= 15                    |   >= 8.0.0                |

Note:
When used with Chef Client 15 and above, the Audit cookbook _must_ be >= 7.7.0. Otherwise, you will see the following failure.
```
Recipe Compile Error in /var/chef/cache/cookbooks/audit/recipes/default.rb
================================================================================

RuntimeError
------------
Audit Mode is enabled. The audit cookbook and Audit Mode cannot be used at the same time. Please disable Audit Mode in your client configuration.
```

## Overview

### Component Architecture
```
 ┌──────────────────────┐    ┌──────────────────────┐    ┌─────────────────────┐
 │     Chef Client      │    │   Chef Server Proxy  │    │    Chef Automate    │
 │                      │    │      (optional)      │    │                     │
 │ ┌──────────────────┐ │    │                      │    │                     │
 │ │                  │◀┼────┼──────────────────────┼────│  Profiles           │
 │ │  audit cookbook  │ │    │                      │    │                     │
 │ │                  │─┼────┼──────────────────────┼───▶│  Reports            │
 │ └──────────────────┘ │    │                      │    │                     │
 │                      │    │                      │    │                     │
 └──────────────────────┘    └──────────────────────┘    └─────────────────────┘
```

InSpec Profiles can be hosted from a variety of locations:

```
 ┌──────────────────────┐                                ┌─────────────────────┐
 │     Chef Client      │     ┌───────────────────────┐  │    Chef Automate    │
 │                      │  ┌──│ Profiles(Supermarket, │  │                     │
 │ ┌──────────────────┐ │  │  │ Github, local, etc)   │  │                     │
 │ │                  │◀┼──┘  └───────────────────────┘  │                     │
 │ │  audit cookbook  │◀┼────────────────────────────────│  Profiles           │
 │ │                  │─┼───────────────────────────────▶│  Reports            │
 │ └──────────────────┘ │                                │                     │
 │                      │                                │                     │
 └──────────────────────┘                                └─────────────────────┘
```

## Usage

The audit cookbook needs to be configured for each node where the `chef-client` runs. The `audit` cookbook can be reused for all nodes, all node-specific configuration is done via Chef attributes.

### InSpec Gem Installation

Beginning with version 3.x of the `audit` cookbook, the cookbook will first check to see if InSpec is already installed. If it is, it will not attempt to install it. Future releases of the Chef omnibus package are expected to include InSpec so this will reduce audit run times and also ensure that Chef users in air-gapped or firewalled environments can still use the `audit` cookbook without requiring gem mirrors, etc.

Also beginning with version 3.x of the `audit` cookbook, the default version of the InSpec gem to be installed (if it isn't already installed) is the latest version. Prior versions of the `audit` cookbook were version-locked to `inspec` version 1.15.0.

To install a different version of the InSpec gem, or to force installation of the gem, set the `node['audit']['inspec_version']` attribute to the version you wish to be installed.

**Starting with Chef Infra Client 15, only the embedded InSpec gem can be used and the `inspec_version` attribute will be ignored.**

Note on AIX Support:

 * InSpec is only supported via the bundled InSpec gem shipped with version >= 13 of the chef-client package.
 * Standalone InSpec gem installation or upgrade is not supported.
 * The default `nil` value of `node['audit']['inspec_version']` will ensure the above behavior is adhered to.

### Configure node

Once the cookbook is available in Chef Server, you need to add the `audit::default` recipe to the run-list of each node (or, preferably create a wrapper cookbook). The profiles are selected using the `node['audit']['profiles']` attribute. A list of example configurations are documented in [Supported Configurations](docs/supported_configuration.md). Below is another example demonstrating the different locations profiles can be "fetched" from:

```ruby
default['audit']['profiles']['linux-baseline'] = {
  'compliance': 'user/linux-baseline',
  'version': '2.1.0'
}

default['audit']['profiles']['ssh'] = {
  'supermarket': 'hardening/ssh-hardening'
}

default['audit']['profiles']['brewinc/win2012_audit'] = {
  'path': 'E:/profiles/win2012_audit'
}

default['audit']['profiles']['ssl'] = {
  'git': 'https://github.com/dev-sec/ssl-benchmark.git'
}

default['audit']['profiles']['ssh2'] = {
  'url': 'https://github.com/dev-sec/tests-ssh-hardening/archive/master.zip'
}
```

#### Inputs

You can also pass in [InSpec Inputs](https://www.inspec.io/docs/reference/inputs/) to your audit run. Do this by defining the attributes:

```ruby
default['audit']['inputs'] = {
  first_input: 'some value',
  second_input: 'another value',
}
```

### Reporting

#### Reporting to Chef Automate via Chef Server

To retrieve compliance profiles and report to Chef Automate through Chef Server, set the `reporter` and `profiles` attributes.

This requires Chef Client >= 12.16.42, Chef Server version 12.11.1, and Chef Automate 0.6.6 or newer, as well as integration between the Chef Server and Chef Automate. More details [here](https://docs.chef.io/integrate_compliance_chef_automate.html#collector-chef-server-automate).

To upload profiles, you can use the [Automate API](https://docs.chef.io/api_automate.html) or the `inspec compliance` subcommands (requires InSpec 1.7.2 or newer).

Attributes example of fetching from Automate, reporting to Automate both via Chef Server:

```ruby
default['audit']['reporter'] = 'chef-server-automate'
default['audit']['fetcher'] = 'chef-server'
default['audit']['profiles']['my-profile'] = {
  'compliance': 'john/my-profile'
}
```

#### Direct reporting to Chef Automate

To report directly to Chef Automate, set the `reporter` attribute to 'chef-automate' and specify where to fetch the `profiles` from.

* `insecure` - a `true` value will skip the SSL certificate verification. Default value is `false`

This method sends the report using the `data_collector.server_url` and `data_collector.token` options, defined in `client.rb`. It requires `inspec` version `0.27.1` or greater. Further information is available at Chef Docs: [Configure a Data Collector token in Chef Automate](https://docs.chef.io/ingest_data_chef_automate.html)

```ruby
default['audit']['reporter'] = 'chef-automate'
default['audit']['profiles']['tmp_compliance_profile'] = {
  'url': 'https://github.com/nathenharvey/tmp_compliance_profile'
}
```

If you are using a self-signed certificate, please also read [how to add the Chef Automate certificate to the trusted_certs directory](https://docs.chef.io/data_collection_without_server.html#add-chef-automate-certificate-to-trusted-certs-directory)

Version compatibility matrix:

| Automate version   | InSpec version   | Audit Cookbook version   |
|--------------------|------------------|--------------------------|
|   < 0.8.0          |   ≤ 1.23.0       |   ≤ 3.1.0                |
|   ≥ 0.8.0          |   ≥ 1.24.0       |   ≥ 4.0.0                |


#### Compliance report size limitations

The size of the report being generated from running the compliance scan is influenced by a few factors like:
 * number of controls and tests in a profile
 * number of profile failures for the node
 * controls metadata (title, description, tags, etc)
 * number of resources (users, processes, etc) that are being tested

Depending on your setup, there are some limits you need to be aware of. A common one is Chef Server default (1MB) request size. Exceeding this limit will reject the report with `ERROR: 413 "Request Entity Too Large"`. For more details about these limits, please refer to [TROUBLESHOOTING.md](TROUBLESHOOTING.md#413-request-entity-too-large).

#### Write to file on disk

To write the report to a file on disk, simply set the `reporter` to 'json-file' like so:

```ruby
default['audit']['reporter'] = 'json-file'
default['audit']['profiles']['ssh2'] = {
  'path': '/some/base_ssh.tar.gz'
}
```

The resulting file will be written to `node['audit']['json_file']['location']` which defaults to
`<chef_cache_path>/cookbooks/audit/inspec-<YYYYMMDDHHMMSS>.json`. The path will also be output to
the Chef log:

```
[2017-08-29T00:22:10+00:00] INFO: Reporting to json-file
[2017-08-29T00:22:10+00:00] INFO: Writing report to /opt/kitchen/cache/cookbooks/audit/inspec-20170829002210.json
[2017-08-29T00:22:10+00:00] INFO: Report handlers complete
```

#### Enforce compliance with executed profiles

The `audit-enforcer` enables you to enforce compliance with executed profiles. If the system under test is determined to be non-compliant, this reporter will raise an error and fail the Chef Client run. To activate compliance enforcement, set the `reporter` attribute to 'audit-enforcer':

```ruby
default['audit']['reporter'] = 'audit-enforcer'
```

Note that detection of non-compliance will immediately terminate the Chef Client run. If you specify [multiple reporters](#multiple-reporters), place the `audit-enforcer` at the end of the list, allowing the other reporters to generate their output prior to run termination.

#### Multiple Reporters

To enable multiple reporters, simply define multiple reporters with all the necessary information
for each one.  For example, to report to Chef Automate and write to json file on disk:

```ruby
default['audit']['reporter'] = ['chef-server-automate', 'json-file']
default['audit']['profiles']['windows'] = {
  'compliance': 'base/windows'
}
)
```

### Profile Fetcher

#### Fetch profiles from Chef Automate via Chef Server

To enable reporting to Chef Automate with profiles from Chef Automate, you need to have Chef Server integrated with [Chef Automate](https://docs.chef.io/integrate_compliance_chef_automate.html#collector-chef-server-automate). You can then set the `fetcher` attribute to 'chef-server'.

This allows the audit cookbook to fetch profiles stored in Chef Automate. For example:

```ruby
default['audit']['reporter'] = 'chef-server-automate'
default['audit']['fetcher'] = 'chef-server'
default['audit']['profiles']['ssh'] = {
  'compliance': 'base/ssh'
}
```

#### Fetch profiles directly from Chef Automate

This method fetches profiles using the `data_collector.server_url` and `data_collector.token` options, in `client.rb`. It requires `inspec` version `0.27.1` or greater. Further information is available at Chef Docs: [Configure a Data Collector token in Chef Automate](https://docs.chef.io/ingest_data_chef_automate.html)

```ruby
default['audit']['reporter'] = 'chef-automate'
default['audit']['fetcher'] = 'chef-automate'
default['audit']['profiles']['ssh'] = {
  'name': 'ssh',
}
```

## Relationship with Chef Audit Mode

The following tables compares the [Chef Client audit mode](https://docs.chef.io/ctl_chef_client.html#run-in-audit-mode) with this `audit` cookbook.

|                                          | audit mode | audit cookbook |
|------------------------------------------|------------|----------------|
| Execution Engine                         | [Serverspec](http://serverspec.org/) | [InSpec](https://github.com/chef/inspec) |
| Execute InSpec Profiles                  | No         | Yes            |
| Execute tests embedded in Chef recipes   | Yes        | No             |

Eventually the `audit` cookbook will replace audit mode. The only drawback is that you will not be able to execute tests in Chef recipes, but since you will be running these tests in production, you will want to have a straightforward, consistent process by which you include these tests throughout your development lifecycle. Within Chef Automate, this is a profile.

### Migrating from audit mode to audit cookbook:

We will improve the migration and help to ease the process and to reuse existing audit mode test as much as possible. At this point of time, an existing audit-mode test like:

```
control_group 'Check SSH Port' do
  control 'SSH' do
    it 'should be listening on port 22' do
      expect(port(22)).to be_listening
    end
  end
end
```

can be re-written in InSpec as follows:

```
# rename `control_group` to `control` and use a unique identifier
control "blog-1" do
  title 'Check SSH Port'  # add the title from `control_group`
  # rename the old `control` to `describe`
  describe 'SSH' do
    it 'should be listening on port 22' do
      expect(port(22)).to be_listening
    end
  end
end
```

or even simplified to:

```
control "blog-1" do
  title 'SSH should be listening on port 22'
  describe port(22) do
    it { should be_listening }
  end
end
```

### Disabling 'audit mode' in  the Chef client

The audit cookbook and Chef's own "Audit Mode" are not compatible due to global state management done by RSpec which is used by both implementations. To prevent unexpected results, the audit cookbook will prevent Chef from continuing if "Audit Mode" is not disabled.

You can use the [chef-client cookbook](https://supermarket.chef.io/cookbooks/chef-client) to disable "Audit Mode" on all of your nodes to permit use of the audit cookbook. As an example, when using the chef-client cookbook you can add this configuration to `default_attributes` section of a role and add the chef-client cookbook to the run list.

```
"chef_client": {
  "config": {
    "audit_mode": ":disabled"
  }
},
```

## Interval Settings

If you have long running audit profiles that you don't wish to execute on every chef-client run,
you can enable an interval:

```
default['audit']['interval']['enabled'] = true
default['audit']['interval']['time'] = 1440 # once a day, the default value
```

The time attribute is in minutes.

You can enable the interval and set the interval time, along with your desired profiles,
 in an environment or role like this:

```json
  "audit": {
    "profiles": [
      {
        "name": "ssh",
        "compliance": "base/ssh"
      },
      {
        "name": "linux",
        "compliance": "base/linux"
      }
    ],
    "interval": {
      "enabled": true,
      "time": 1440
    }
  }
```

## Alternate Source Location for `inspec` Gem

If you are not able or do not wish to pull the `inspec` gem from rubygems.org,
you may specify an alternate source using:

```
# URI to alternate gem source (e.g. http://gems.server.com or filesytem location)
# root of location must host the *specs.4.8.gz source index
default['audit']['inspec_gem_source'] = 'http://internal.gem.server.com/gems'
```

Please note that all dependencies to the `inspec` gem must also be hosted in this location.

## Using Chef node data

While it is recommended that InSpec profiles should be self-contained and not rely on external data unless
necessary, there are valid use cases where a profile's test may exhibit different behavior depending on
aspects of the node under test.

There are two primary ways to pass Chef data to the InSpec run via the audit cookbook.

### Option 1: Explicitly pass necessary data (recommended)

Any data added to the `node['audit']['attributes']` hash will be passed as individual InSpec attributes.
This provides a clean interface between the Chef run and InSpec profile, allowing for easy assignment
of sane default values in the InSpec profile. This method is especially recommended if the InSpec profile
is expected to be used outside of the context of the audit cookbook so it's extra clear to profile
consumers what attributes are necessary.

In a wrapper cookbook or similar, set your Chef attributes:

```ruby
node.normal['audit']['attributes']['key1'] = 'value1'
node.normal['audit']['attributes']['debug_enabled'] = node['my_cookbook']['debug_enabled']
node.normal['audit']['attributes']['environment'] = node.chef_environment
```

... and then use them in your InSpec profile:

```ruby
environment = attribute('environment', description: 'The chef environment for the node', default: 'dev')

control 'debug-disabled-in-production' do
  title 'Debug logs disabled in production'
  desc 'Debug logs contain potentially sensitive information and should not be on in prod.'
  impact 1.0

  describe file('/path/to/my/app/config') do
    its('content') { should_not include "debug=true" }
  end

  only_if { environment == 'production' }
end
```

### Option 2: Use the chef node object

In the event where it is not practical to opt-in to pass certain attributes and data, the audit cookbook will
pass the Chef node object as an InSpec attribute named `chef_node`.

While this provides the ability to write more flexible profiles, it makes it more difficult to reuse profiles
outside of an audit cookbook run, requiring the profile user to know how to pass in a single attribute containing
Chef-like data. Therefore, it is recommended to use Option 1 whenever possible.

To use this option, first enable it in a wrapper cookbook or similar:

```ruby
node.override['audit']['chef_node_attribute_enabled'] = true
```

... and then use it in your profile:

```ruby
chef_node = attribute('chef_node', description: 'Chef Node')

control 'no-password-auth-in-prod' do
  title 'No Password Authentication in Production'
  desc 'Password authentication is allowed in all environments except production'
  impact 1.0

  describe sshd_config do
    its('PasswordAuthentication') { should cmp 'No' }
  end

  only_if { chef_node['chef_environment'] == 'production' }
end
```

## Using the InSpec Backend Cache

**Introduced in Audit Cookbook v6.0.0 and InSpec v1.47.0**

InSpec v1.47.0 provides the ability to cache the result of commands executed on the node being tested. This drastically improves InSpec performance when slower-running commands are run multiple times during execution.

This feature is **enabled by default** in the audit cookbook. If your profile runs a command multiple times and expects output to be different each time, you may have to disable this feature. To do so, set the `inspec_backend_cache` attribute to `false`:

```ruby
node.normal['audit']['inspec_backend_cache'] = false
```

## Troubleshooting

Please refer to [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

Please let us know if you have any [issues](https://github.com/chef-cookbooks/audit/issues), we are happy to help.

## Run the tests for this cookbook:

Install [Chef Development Kit](https://downloads.chef.io/chefdk) on your machine.

```bash
# Install webmock gem needed by rspec
chef gem install webmock

# Run style checks
rake style

# Run all unit and ChefSpec tests
rspec

# Run a specific test
rspec ./spec/unit/libraries/automate_spec.rb
```

## How to release the `audit` cookbook

* Cookbook source located here: (https://github.com/chef-cookbooks/audit)
* Hosted Chef users("collaborators") that can publish it to supermarket.chef.io: `apop`, `arlimus`, `chris-rock`, `sr`. Add more collaborators from `Supermarket>Manage Cookbook>Add Collaborator`

Releasing a new cookbook version:

1. Install changelog gem: `chef gem install github_changelog_generator`
2. version bump the metadata.rb and updated changelog (`rake changelog`)
3. Get your changes merged into master
4. Go to the `audit` cookbook directory and pull from master
5. Run `bundle install`
6. Use stove to publish the cookbook(including git version tag). You must point to the private key of your hosted chef user. For example:

  ```
  stove --username apop --key ~/git/chef-repo/.chef/apop.pem
  ```

## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Stephan Renatus (<srenatus@chef.io>)
| **Author:**          | Christoph Hartmann (<chartmann@chef.io>)
| **Copyright:**       | Copyright (c) 2015 Chef Software Inc.
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[cookbook]: https://supermarket.chef.io/cookbooks/audit
[travis]: http://travis-ci.org/chef-cookbooks/audit
