# audit cookbook
[![Cookbook Version](http://img.shields.io/cookbook/v/audit.svg)][cookbook] [![Build Status](http://img.shields.io/travis/chef-cookbooks/audit.svg)][travis]

The `audit` cookbook allows you to run InSpec profiles as part of a Chef Client run. It downloads configured profiles from various sources like Chef Compliance, Chef Supermarket or Git and reports audit runs to Chef Compliance or Chef Visibility.

Version 2.0 of the audit cookbook is based on an idea from [Michael Hedgpeth](https://github.com/chef-cookbooks/audit/issues/70). Under the hood it uses [Chef handler](https://docs.chef.io/handlers.html) instead of Chef resources now.

## Requirements

### Chef

- Chef Client >=12.5.1

### Chef Compliance and InSpec

Using the `inspec_version` attribute, please use the following `InSpec` version based on your Chef Compliance version:

| Chef Compliance version    | InSpec version             | Audit Cookbook  version    |
|----------------------------|----------------------------|----------------------------|
| Less or equal to 1.1.23    | 0.20.1                     | 0.7.0                      |
| Greater than 1.1.23        | Greater or equal to 0.22.1 | 0.8.0                      |
| Greater or equal to 1.6.8  | Greater or equal to 1.2.0  | 1.0.2                      |


You can see all publicly available InSpec versions [here](https://rubygems.org/gems/inspec/versions)

## Overview

The `audit` support three scenarios:

### Chef Server Integration

The first scenario requires at least **Chef Compliance 1.0** and the **[Chef Server extensions for Compliance](https://docs.chef.io/integrate_compliance_chef_server.html)**. The architecture looks as following:

```
 ┌──────────────────────┐    ┌──────────────────────┐    ┌─────────────────────┐
 │     Chef Client      │    │     Chef Server      │    │   Chef Compliance   │
 │                      │    │                      │    │                     │
 │ ┌──────────────────┐ │    │                      │    │                     │
 │ │                  │◀┼────┼──────────────────────┼────│  Profiles           │
 │ │  audit cookbook  │ │    │                      │    │                     │
 │ │                  │─┼────┼──────────────────────┼───▶│  Reports            │
 │ └──────────────────┘ │    │                      │    │                     │
 │                      │    │                      │    │                     │
 └──────────────────────┘    └──────────────────────┘    └─────────────────────┘
```

### Chef Compliance Integration

The second scenario supports a direct connection with Chef Compliance. It also supports chef-solo mode.

```
 ┌──────────────────────┐                                ┌─────────────────────┐
 │     Chef Client      │                                │   Chef Compliance   │
 │                      │                                │                     │
 │ ┌──────────────────┐ │                                │                     │
 │ │                  │◀┼────────────────────────────────│  Profiles           │
 │ │  audit cookbook  │ │                                │                     │
 │ │                  │─┼───────────────────────────────▶│  Reports            │
 │ └──────────────────┘ │                                │                     │
 │                      │                                │                     │
 └──────────────────────┘                                └─────────────────────┘
```

### Chef Visibility Integration

The third scenario supports direct reporting to Chef Visibility. It also supports chef-solo mode.

```
 ┌──────────────────────┐                                ┌─────────────────────┐
 │     Chef Client      │     ┌───────────────────────┐  │   Chef Visibility   │
 │                      │  ┌──│ Profiles(Supermarket, │  │                     │
 │ ┌──────────────────┐ │  │  │ Github, local, etc)   │  │                     │
 │ │                  │◀┼──┘  └───────────────────────┘  │                     │
 │ │  audit cookbook  │ │                                │                     │
 │ │                  │─┼───────────────────────────────▶│  Reports            │
 │ └──────────────────┘ │                                │                     │
 │                      │                                │                     │
 └──────────────────────┘                                └─────────────────────┘
```


## Usage

The audit cookbook needs to be configured for each node where the `chef-client` runs. The `audit` cookbook can be reused for all nodes, all node-specific configuration is done via Chef attributes.

### Upload cookbook to Chef Server

The `audit` cookbook is available at [Chef Supermarket](https://supermarket.chef.io/cookbooks/audit). This allows you to reuse your existing workflow for managing cookbooks in your runlist.

If you want to upload the cookbook from git, use the following commands:

```
mkdir chef-cookbooks
cd chef-cookbooks
git clone https://github.com/chef-cookbooks/audit
cd ..
knife cookbook upload audit -o ./chef-cookbooks
```

Please ensure that `chef-cookbooks` is the parent directory of `audit` cookbook.


#### Reporting to Chef Compliance via Chef Server

If you want the audit cookbook to converge and retrieve compliance profiles through the Chef Server, set the `collector` and `profiles` attribute.

This requires your Chef Server to be integrated with the Chef Compliance server using this [guide](https://docs.chef.io/integrate_compliance_chef_server.html).

#### Configure node

Once the cookbook is available in Chef Server, you need to add the `audit::default` recipe to the run-list of each node. The profiles are selected via the `node['audit']['profiles']` attribute. For example you can define the attributes in a role or environment file like this:


node.default['audit']['profiles'].push("path": "#{PROFILES_PATH}/mylinux-failure-success")

```ruby
"audit" => {
  "collector" => "chef-server",
  "inspec_version" => "1.2.1",
  "profiles" => [
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
default['audit'] = {
  'collector' => 'chef-server',
  'profiles' => [
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


#### Direct reporting to Chef Compliance

If you want the audit cookbook to directly report to Chef Compliance, set the `collector`, `server`, `owner`, `refresh_token` and `profiles` attributes.

 * `collector` - 'chef-compliance' to report to Chef Compliance
 * `server` - url of Chef Compliance server with `/api`
 * `owner` - Chef Compliance user or organization that will receive this scan report
 * `refresh_token` - refresh token for Chef Compliance API (https://github.com/chef/inspec/issues/690)
   * note: A UI logout revokes the refresh_token. Workaround by logging in once in a private browser session, grab the token and then close the browser without logging out
 * `insecure` - a `true` value will skip the SSL certificate verification when retrieving access token. Default value is `false`

```ruby
"audit": {
  "collector": "chef-compliance",
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
  "collector": "chef-compliance",
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


#### Direct reporting to Chef Visibility

If you want the audit cookbook to directly report to Chef Visibility, set the `collector` attribute to 'chef-visibility'. Also specify where to retrieve the `profiles` from.

* `insecure` - a `true` value will skip the SSL certificate verification. Default value is `false`

This method is sending the report using the `data_collector.server_url` and `data_collector.token`, defined in `client.rb`. It requires `inspec` version `0.27.1` or greater.

```ruby
"audit": {
  "collector": "chef-visibility",
  "insecure": "false",
  "profiles": [
    {
      "name": "brewinc/tmp_compliance_profile",
      "url": "https://github.com/nathenharvey/tmp_compliance_profile"
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
  server: 'https://compliance-server.test/api'
  collector: 'chef-compliance',
  refresh_token: '21/XMEK3...',
  profiles: [
   {
      'name': 'admin/ssh2',
      'path': '/some/base_ssh.tar.gz'
    }
  ]
}
```

## Write to file on disk

To write the report to a file on disk, simply set the collector to 'json-file' like so:

```ruby
audit: {
  collector: 'json-file',
  profiles: [
   {
      'name': 'admin/ssh2',
      'path': '/some/base_ssh.tar.gz'
    }
  ]
}
```

## Multiple reporters

To enable multiple reporters, simply define multiple reporters with all the necessary information
for each one.  For example, to report to chef-compliance and write to json file on disk:

```ruby
"audit": {
  "collector": [ "chef-compliance", "json-file" ]
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

## Fetcher attribute

To enable reporting to chef-visibility with profiles from chef-compliance, you need to have chef-server integrated with chef-compliance. You can then set the fetcher attribute to 'chef-server'.
This will allow the audit cookbook to fetch the profile from chef-compliance.  For example:

```ruby
"audit": {
  "fetcher": 'chef-server'
  "collector": 'chef-visibility'
  "profiles": [
    {
      "name": "ssh",
      "compliance": "base/ssh"
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
