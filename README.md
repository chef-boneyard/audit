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

The `audit` requires at least **Chef Compliance 1.0** and the **Chef Server extensions for Compliance**. The architecture looks as following:

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

## Usage

The audit cookbook needs to be configured for each node where the `chef-client` runs. The `audit` cookbook can be reused for all nodes, all node-specific configuration is done via Chef attributes.

### Upload cookbook to Chef Server

The `audit` cookbook is available at [Chef Supermarket](https://supermarket.chef.io/cookbooks/audit). This allows you to reuse the existing workflow.

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

Once the cookbook is available in Chef Server, you need to add the `audit::default` recipe to the run-list of each node. The profiles are selected via the `node['audit']['profiles']` attribute. For example, to run the `base/ssh` and `base/linux` profiles, you can define the attribute in a JSON-based role or environment file like this:

```ruby
  audit = {
    "inspec_version" => "0.22.0",
    "profiles" => {
      # org / profile name
      'base/linux' => true,
      'brewinc/ssh-hardening' => {
        # where inspec will fetch from
        'source' => 'supermarket://hardening/ssh-hardening',
        'key' => 'value',
      },
      # Windows path
      'brewinc/win2012_audit' => {
        # filesystem path
        'source' => 'E:/profiles/win2012_audit',
      },
      'brewinc/tmp_compliance_profile' => {
        # github
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

## How does it relate to Chef Audit Mode

The following tables compares the [Chef Client audit mode](https://docs.chef.io/ctl_chef_client.html#run-in-audit-mode) with this `audit` cookbook.

|                                          | audit mode | audit cookbook |
|------------------------------------------|------------|----------------|
| Works with Chef Compliance               | No         | Yes            |
| Execution Engine                         | [Serverspec](http://serverspec.org/) | [InSpec](https://github.com/chef/inspec) |
| Execute InSpec Compliance Profiles       | No         | Yes            |
| Execute tests embedded in Chef recipes   | Yes        | No             |

### How to migrate from audit mode to audit cookbook:

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
you can use the interval recipe instead of the default recipe in your runlist, and set the
following attributes:

```
default['audit']['interval']['enabled'] = false
default['audit']['interval']['time'] = 1440
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
      "enabled": "true",
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
