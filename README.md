# audit cookbook
[![Cookbook Version](http://img.shields.io/cookbook/v/audit.svg)][cookbook] [![Build Status](http://img.shields.io/travis/chef-cookbooks/audit.svg)][travis]

The `audit` cookbook allows you to run InSpec profiles as part of a Chef Client run. It downloads configured profiles from various sources like Chef Compliance, Chef Supermarket or Git and reports audit runs to Chef Compliance or Chef Automate.

## Requirements

### Chef

- Chef Client >=12.5.1

### Support Matrix

#### Chef Automate

| Automate version   | InSpec version   | Audit Cookbook version   |
|--------------------|------------------|--------------------------|
|   < 0.8.0          |   ≤ 1.23.0       |   ≤ 3.1.0                |
|   ≥ 0.8.0          |   ≥ 1.24.0       |   ≥ 4.0.0                |

#### Chef Compliance

| Chef Compliance version    | InSpec version    | Audit Cookbook version    |
|----------------------------|-------------------|---------------------------|
|   ≤ 1.1.23                 |   = 0.20.1        |   = 0.7.0                 |
|   > 1.1.23                 |   ≥ 0.22.1        |   = 0.8.0                 |
|   ≥ 1.6.8                  |   ≥ 1.2.0         |   > 1.0.2                 |


## Deprecation Note:

### Please use `reporter` instead of `collector` attribute

With version 3.1.0 the use of the `collector` attribute is deprecated. Please use `reporter` instead. The `collector` attribute will be removed in the next major version.

```
"audit": {
  "collector": "chef-server-compliance",
```

becomes:

```
"audit": {
  "reporter": "chef-server-compliance",
```

### Use `chef-server-automate` and `chef-automate` instead of `chef-server-visibility` and `chef-visibility`

With version 3.1.0 the reporter attribute deprecates the values `chef-server-visibility` and `chef-visibility`. They have been renamed:

 * `chef-server-visibility` => `chef-server-automate`
 * `chef-visibility` => `chef-automate`

The support for values `chef-server-visibility` and `chef-visibility` will be removed in the next major version.


## Overview

### Component Architecture
```
 ┌──────────────────────┐    ┌──────────────────────┐    ┌─────────────────────┐
 │     Chef Client      │    │   Chef Server Proxy  │    │   Chef Compliance   │
 │                      │    │      (optional)      │    │   or Chef Automate  │
 │ ┌──────────────────┐ │    │                      │    │                     │
 │ │                  │◀┼────┼──────────────────────┼────│  Profiles           │
 │ │  audit cookbook  │ │    │                      │    │                     │
 │ │                  │─┼────┼──────────────────────┼───▶│  Reports            │
 │ └──────────────────┘ │    │                      │    │                     │
 │                      │    │                      │    │                     │
 └──────────────────────┘    └──────────────────────┘    └─────────────────────┘
```

Inspec Profiles can be hosted from a variety of locations:
```
 ┌──────────────────────┐                                ┌─────────────────────┐
 │     Chef Client      │     ┌───────────────────────┐  │   Chef Compliance   │
 │                      │  ┌──│ Profiles(Supermarket, │  │   or Chef Automate  │
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

### Configure node

Once the cookbook is available in Chef Server, you need to add the `audit::default` recipe to the run-list of each node. The profiles are selected via the `node['audit']['profiles']` attribute. A complete list of the possible configuration are documented in [Supported Configurations](docs/supported_configuration.md). For example you can define the attributes in a role or environment file like this:


node.default['audit']['profiles'].push("path": "#{PROFILES_PATH}/mylinux-failure-success")

```ruby
"audit": {
  "reporter": "chef-server-compliance",
  "inspec_version": "1.2.1",
  "profiles": [
    # profile from Chef Compliance
    {
      "name": "linux",
      "compliance": "base/linux"
    },
    # profile from supermarket
    # note: If reporting to Compliance, the Supermarket profile needs to be uploaded to Chef Compliance first
    {
      "name": "ssh",
      "supermarket": "hardening/ssh-hardening"
    },
    # local Windows path
    {
      "name": "brewinc/win2012_audit",
      # filesystem path
      "path": "E:/profiles/win2012_audit"
    },
    # github
    {
      "name": "ssl",
      "git": "https://github.com/dev-sec/ssl-benchmark.git"
    },
    # url
    {
      "name": "ssh",
      "url": "https://github.com/dev-sec/tests-ssh-hardening/archive/master.zip"
    }
  ]
}
```

You can also configure in a policyfile like this:

```ruby
default["audit"] = {
  "reporter" => "chef-server-compliance",
  "profiles" => [
    {
      "name": "linux",
      "compliance": "base/linux"
    },
    {
      "name": "ssh",
      "compliance": "base/ssh"
    }
  ]
}
```

### Reporting

#### Reporting to Chef Automate via Chef Server

If you want the audit cookbook to retrieve compliance profiles and report to Chef Automate (Visibility) through Chef Server, set the `reporter` and `profiles` attributes.

This requires Chef Client >= 12.16.42.  Also requires Chef Server version 12.11.1 and Chef Automate 0.6.6 or newer, as well as integration between the two. More details [here](https://docs.chef.io/integrate_compliance_chef_automate.html#collector-chef-server-automate).

Chef Automate is not shipping with build-in profiles at the moment. To upload profiles, you can use the [Automate API](https://docs.chef.io/api_delivery.html) or the `inspec compliance` subcommands (requires InSpec 1.7.2 or newer).

Attributes example of fetching from Automate, reporting to Automate both via Chef Server:

```ruby
"audit": {
  "reporter": "chef-server-automate",
  "fetcher": "chef-server",
  "insecure": false,
  "profiles": [
    {
      "name": "my-profile",
      "compliance": "john/my-profile"
    }
  ]
}
```


#### Direct reporting to Chef Compliance

If you want the audit cookbook to directly report to Chef Compliance, set the `reporter`, `server`, `owner`, `refresh_token` and `profiles` attributes.

 * `reporter` - 'chef-compliance' to report to Chef Compliance
 * `server` - url of Chef Compliance server with `/api`
 * `owner` - Chef Compliance user or organization that will receive this scan report
 * `refresh_token` - refresh token for Chef Compliance API (https://github.com/chef/inspec/issues/690)
   * note: A UI logout revokes the refresh_token. Workaround by logging in once in a private browser session, grab the token and then close the browser without logging out
 * `insecure` - a `true` value will skip the SSL certificate verification when retrieving access token. Default value is `false`

```ruby
"audit": {
  "reporter": "chef-compliance",
  "server": "https://compliance-fqdn/api",
  "owner": "my-comp-org",
  "refresh_token": "5/4T...g==",
  "insecure": false,
  "profiles": [
    {
      "name": "windows",
      "compliance": "base/windows"
    }
  ]
}
```

Instead of a refresh token, it is also possible to use a `token` that expires in 12h after creation .

```ruby
"audit": {
  "reporter": "chef-compliance",
  "server": "https://compliance-fqdn/api",
  "owner": "my-comp-org",
  "token": "eyJ........................YQ",
  "profiles": [
    {
      "name": "windows",
      "compliance": "base/windows"
    }
  ]
}
```

#### Direct reporting to Chef Automate

If you want the audit cookbook to directly report to Chef Automate, set the `reporter` attribute to 'chef-automate'. Also specify where to retrieve the `profiles` from.

* `insecure` - a `true` value will skip the SSL certificate verification. Default value is `false`

This method is sending the report using the `data_collector.server_url` and `data_collector.token`, defined in `client.rb`. It requires `inspec` version `0.27.1` or greater. Further information is available at Chef Docs: [Configure a Data Collector token in Chef Automate](https://docs.chef.io/ingest_data_chef_automate.html)

```ruby
"audit": {
  "reporter": "chef-automate",
  "insecure": "false",
  "profiles": [
    {
      "name": "brewinc/tmp_compliance_profile",
      "url": "https://github.com/nathenharvey/tmp_compliance_profile"
    }
  ]
}
```

If you are using a self-signed certificate, please also read [how to add the Chef Automate certificate to the trusted_certs directory](https://docs.chef.io/setup_visibility_chef_automate.html#add-chef-automate-certificate-to-trusted-certs-directory)

Version compatibility matrix:

| Automate version   | InSpec version   | Audit Cookbook version   |
|--------------------|------------------|--------------------------|
|   < 0.8.0          |   ≤ 1.23.0       |   ≤ 3.1.0                |
|   ≥ 0.8.0          |   ≥ 1.24.0       |   ≥ 4.0.0                |


#### Write to file on disk

To write the report to a file on disk, simply set the `reporter` to 'json-file' like so:

```ruby
audit: {
  reporter: 'json-file',
  profiles: [
   {
      'name': 'admin/ssh2',
      'path': '/some/base_ssh.tar.gz'
    }
  ]
}
```

#### Multiple Reporters

To enable multiple reporters, simply define multiple reporters with all the necessary information
for each one.  For example, to report to chef-compliance and write to json file on disk:

```ruby
"audit": {
  "reporter": [ "chef-compliance", "json-file" ]
  "server": "https://compliance-fqdn/api",
  "owner": "my-comp-org",
  "refresh_token": "5/4T...g==",
  "insecure": false,
  "profiles": [
    {
      "name": "windows",
      "compliance": "base/windows"
    }
  ]
}
```

### Profile Fetcher

#### Fetch profiles from Chef Automate/Chef Compliance via Chef Server

To enable reporting to Chef Automate with profiles from Chef Compliance or Chef Automate, you need to have Chef Server integrated with [Chef Compliance or Chef Automate](https://docs.chef.io/integrate_compliance_chef_automate.html#collector-chef-server-automate). You can then set the `fetcher` attribute to 'chef-server'.
This will allow the audit cookbook to fetch profiles stored in Chef Compliance. For example:

```ruby
"audit": {
  "fetcher": "chef-server",
  "reporter": "chef-server-automate",
  "profiles": [
    {
      "name": "ssh",
      "compliance": "base/ssh"
    }
  ]
}
```

#### Fetch profiles directly from Chef Automate

This method is fetching profiles using the `data_collector.server_url` and `data_collector.token`, defined in `client.rb`. It requires `inspec` version `0.27.1` or greater. Further information is available at Chef Docs: [Configure a Data Collector token in Chef Automate](https://docs.chef.io/ingest_data_chef_automate.html)

```ruby
"audit": {
  "fetcher": "chef-automate",
  "reporter": "chef-automate",
  "profiles": [
    {
      "name": "ssh",
      "compliance": "base/ssh"
    }
  ]
}
```

## Profile Upload to Compliance Server

In order to support build cookbook mode, the `compliance_profile` resource has an `upload` action that allows uploading a compressed
inspec compliance profile to the Compliance Server.

Simply include the `upload` recipe in the run_list, with attribute overrides for the `audit` hash like so:

```ruby
audit: {
  server: 'https://compliance-server.test/api',
  reporter: 'chef-compliance',
  refresh_token: '21/XMEK3...',
  profiles: [
   {
      'name': 'admin/ssh2',
      'path': '/some/base_ssh.tar.gz'
    }
  ]
}
```

## Relationship with Chef Audit Mode

The following tables compares the [Chef Client audit mode](https://docs.chef.io/ctl_chef_client.html#run-in-audit-mode) with this `audit` cookbook.

|                                          | audit mode | audit cookbook |
|------------------------------------------|------------|----------------|
| Works with Chef Compliance               | No         | Yes            |
| Execution Engine                         | [Serverspec](http://serverspec.org/) | [InSpec](https://github.com/chef/inspec) |
| Execute InSpec Compliance Profiles       | No         | Yes            |
| Execute tests embedded in Chef recipes   | Yes        | No             |

Eventually the `audit` cookbook will replace audit mode. The only drawback is that you will not be able to execute tests in Chef recipes, but since you will be running these tests in production, you will want to have a straightforward, consistent process by which you include these tests throughout your development lifecycle. Within Chef Compliance, this is a profile.

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

## Troubleshooting

Please refer to TROUBLESHOOTING.md.

Please let us know if you have any [issues](https://github.com/chef-cookbooks/audit/issues), we are happy to help.

## Run the tests for this cookbook:

```bash
bundle install
bundle exec rake style
# run all ChefSpec tests
bundle exec rspec
# run a specific test
bundle exec rspec ./spec/unit/libraries/automate_spec.rb
```

## How to release the `audit` cookbook

* Cookbook source located here: (https://github.com/chef-cookbooks/audit)
* Hosted Chef users("collaborators") that can publish it to supermarket.chef.io: `apop`, `arlimus`, `chris-rock`, `sr`. Add more collaborators from `Supermarket>Manage Cookbook>Add Collaborator`

Releasing a new cookbook version:

1. version bump the metadata.rb and updated changelog (`bundle exec rake changelog`)
2. Get your changes merged into master
3. Go to the `audit` cookbook directory and pull from master
4. Run `bundle install`
5. Use stove to publish the cookbook(including git version tag). You must point to the private key of your hosted chef user. For example:

  ```
  bundle exec stove --username apop --key ~/git/chef-repo/.chef/apop.pem
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
