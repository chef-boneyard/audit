# audit cookbook
[![Cookbook Version](http://img.shields.io/cookbook/v/audit.svg)][cookbook] [![Build Status](http://img.shields.io/travis/chef-cookbooks/audit.svg)][travis]

## Requirements

### Chef
- Chef Client >=12.5.1

The `audit` cookbook allows you to run Chef Compliance profiles as part of a Chef Client run. It downloads configured profiles from Chef Compliance and reports audit runs to Chef Compliance.

### Chef Compliance and InSpec

Using the `inspec_version` attribute, please use the following `InSpec` version based on your Chef Compliance version:

| Chef Compliance version    | InSpec version             | Audit Cookbook  version    |
|----------------------------|----------------------------|----------------------------|
| Less or equal to 1.1.23    | 0.20.1                     | 0.7.0                      |
| Greater than 1.1.23        | Greater or equal to 0.22.1 | 0.8.0                      |


You can see all publicly available InSpec versions [here](https://rubygems.org/gems/inspec/versions)

## Overview

The `audit` support two scenarios:

### Chef Server Integration

The first scenario requires at least **Chef Compliance 1.0** and the **[Chef Server extensions for Compliance](https://docs.chef.io/integrate_compliance_chef_server.html)**. The architecture looks as following:

```
 ┌──────────────────────┐    ┌──────────────────────┐    ┌──────────────────────┐
 │     Chef Client      │    │     Chef Server      │    │   Chef Compliance    │
 │                      │    │                      │    │                      │
 │ ┌──────────────────┐ │    │                      │    │                      │
 │ │                  │◀┼────┼──────────────────────┼────│  Profiles            │
 │ │  audit cookbook  │ │    │                      │    │                      │
 │ │                  │─┼────┼──────────────────────┼───▶│  Reports             │
 │ └──────────────────┘ │    │                      │    │                      │
 │                      │    │                      │    │                      │
 └──────────────────────┘    └──────────────────────┘    └──────────────────────┘
```

### Chef Compliance

The second scenario support a direct connection with Chef Compliance and support chef-solo mode as well.

```
 ┌──────────────────────┐                                ┌──────────────────────┐
 │     Chef Client      │                                │   Chef Compliance    │
 │                      │                                │                      │
 │ ┌──────────────────┐ │                                │                      │
 │ │                  │◀┼────────────────────────────────│  Profiles            │
 │ │  audit cookbook  │ │                                │                      │
 │ │                  │─┼───────────────────────────────▶│  Reports             │
 │ └──────────────────┘ │                                │                      │
 │                      │                                │                      │
 └──────────────────────┘                                └──────────────────────┘
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

### Configure node

Once the cookbook is available in Chef Server, you need to add the `audit::default` recipe to the run-list of each node. The profiles are selected via the `node['audit']['profiles']` attribute. For example you can define the attribute in a JSON-based role or environment file like this:

```ruby
audit = {
  "profiles" => {
    # org / profile name from Chef Compliance
    'base/linux' => true,
    # supermarket url
    'brewinc/ssh-hardening' => {
      # location where inspec will fetch the profile from
      'source' => 'supermarket://hardening/ssh-hardening',
      'key' => 'value',
    },
    # local Windows path
    'brewinc/win2012_audit' => {
      # filesystem path
      'source' => 'E:/profiles/win2012_audit',
    },
    # github url
    'brewinc/tmp_compliance_profile' => {
      'source' => 'https://github.com/nathenharvey/tmp_compliance_profile',
    },
    # disable profile
    'brewinc/tmp_compliance_profile-master' => {
      'source' => '/tmp/tmp_compliance_profile-master',
      'disabled' => true,
    },
  },
}
```

You can also configure in a policyfile like this:

```ruby
default['audit'] = {
  profiles: {
    'base/linux' => true,
    'base/ssh' => true
  }
}
```

#### Direct reporting to Chef Compliance

If you want the audit cookbook directly report to Chef Compliance, set the `server` and the `token` attribute.

 * `server` - url of Chef Compliance server with `/api`
 * `token` - access token for Chef Compliance API (https://github.com/chef/inspec/issues/690)

 If those attributes are missing, the audit cookbook expects the Chef Server integration to be available.

```ruby
audit: {
  server: 'https://compliance-fqdn/api/',
  token: 'eyJ........................YQ',
  profiles: {
    'base/windows'    => true,
  },
}
```

It is also possible to use a `refresh_token` instead of an access token:

```ruby
audit: {
  server: 'https://compliance-fqdn/api/',
  refresh_token: '5/4T...g==',
  profiles: {
    'base/windows'    => true,
  },
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
    "profiles": {
      "base/ssh": true,
      "base/linux": true
    },
    "interval": {
      "enabled": true,
      "time": 1440
    }
  }

```


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
