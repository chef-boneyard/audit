# encoding: utf-8
#
# Cookbook Name:: compliance
# Spec:: default
#
# Copyright 2016 Chef Software, Inc.
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

require 'spec_helper'

describe 'audit::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When two profiles are specified' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.node.set['audit']['profiles'] = { 'admin/myprofile' => true,
                                               'base/ssh' => false }
      runner.converge(described_recipe)
    end

    it 'fetches and executes compliance_profile[myprofile]' do
      expect(chef_run).to fetch_compliance_profile('myprofile').with(
        owner: 'admin',
        server: nil,
        token: nil,
        inspec_version: 'latest',
      )
      expect(chef_run).to execute_compliance_profile('myprofile').with(
        owner: 'admin',
        server: nil,
        token: nil,
        inspec_version: 'latest',
      )
      expect(chef_run).to execute_compliance_report('chef-server').with(
        owner: nil,
        server: nil,
        token: nil,
        variant: 'chef',
      )
    end

    it 'skips compliance_profile[ssh]' do
      expect(chef_run).to_not fetch_compliance_profile('ssh')
      expect(chef_run).to_not execute_compliance_profile('ssh')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When invalid profile is passed' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.node.set['audit']['profiles'] = { 'myprofile' => true }
      runner.converge(described_recipe)
    end

    it 'does raise an error' do
      expect { chef_run }.to raise_error("Invalid profile name 'myprofile'. Must contain /, e.g. 'john/ssh'")
    end
  end
end
