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

  context 'When server and refresh_token are specified' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['audit']['collector'] = 'chef-compliance'
        node.set['audit']['profiles'] = { 'admin/myprofile' => true }
        node.set['audit']['server'] = 'https://my.compliance.test/api'
        node.set['audit']['refresh_token'] = 'abcdefg'
        node.set['audit']['insecure'] = true
      end.converge(described_recipe)
    end

    it 'fetches and executes compliance_profile[myprofile]' do
      expect(chef_run).to fetch_compliance_profile('myprofile').with(
        server: 'https://my.compliance.test/api',
        insecure: true,
      )
      expect(chef_run).to execute_compliance_profile('myprofile').with(
        server: 'https://my.compliance.test/api',
        insecure: true,
      )
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When two profiles are specified' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.node.override['audit']['profiles'] = { 'admin/myprofile' => true,
                                               'base/ssh' => false }
      runner.node.override['audit']['inspec_version'] = 'latest'
      runner.node.override['audit']['quiet'] = true
      runner.converge(described_recipe)
    end

    it 'fetches and executes compliance_profile[myprofile]' do
      expect(chef_run).to fetch_compliance_profile('myprofile').with(
        owner: 'admin',
        server: nil,
        token: nil,
      )
      expect(chef_run).to execute_compliance_profile('myprofile').with(
        owner: 'admin',
        server: nil,
        token: nil,
        quiet: true,
      )
      expect(chef_run).to execute_compliance_report('chef-server').with(
        owner: nil,
        server: nil,
        token: nil,
        quiet: true,
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
      runner.node.override['audit']['profiles'] = { 'myprofile' => true }
      runner.converge(described_recipe)
    end

    it 'does raise an error' do
      expect { chef_run }.to raise_error("Invalid profile name 'myprofile'. Must contain /, e.g. 'john/ssh'")
    end
  end

  context 'When specifying profiles with alternate sources' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.node.override['audit']['profiles'] = {
        'base/linux' => true,
        'base/apache' => false,
        'brewinc/ssh-hardening' => {
          'source' => 'supermarket://hardening/ssh-hardening',
        },
        'brewinc/tmp_compliance_profile' => {
          'source' => 'https://github.com/nathenharvey/tmp_compliance_profile',
        },
        'brewinc/tmp_compliance_profile-master' => {
          'source' => '/tmp/tmp_compliance_profile-master',
        },
        'exampleorg/myprofile' => {
          'disabled' => true,
        },
      }
      runner.converge(described_recipe)
    end
    it 'executes base/linux in backward compatible mode' do
      expect(chef_run).to execute_compliance_profile('linux').with(
        path: nil,
      )
    end
    it 'executes brewinc/ssh-hardening from supermarket' do
      expect(chef_run).to execute_compliance_profile('ssh-hardening').with(
        path: 'supermarket://hardening/ssh-hardening',
      )
    end
    it 'executes brewinc/tmp_compliance_profile from github' do
      expect(chef_run).to execute_compliance_profile('tmp_compliance_profile').with(
        path: 'https://github.com/nathenharvey/tmp_compliance_profile',
      )
    end
    it 'executes brewinc/tmp_compliance_profile-master from filesystem' do
      expect(chef_run).to execute_compliance_profile('tmp_compliance_profile-master').with(
        path: '/tmp/tmp_compliance_profile-master',
      )
    end
    it 'does not execute disabled exampleorg/myprofile' do
      expect(chef_run).to_not execute_compliance_profile('myprofile')
    end
    it 'executes execute_compliance_report[chef-server]' do
      expect(chef_run).to execute_compliance_report('chef-server')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'when set to run on an interval and not due to run' do
    before(:each) do
      allow_any_instance_of(Chef::Resource).to receive(:profile_overdue_to_run?).and_return(false)
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.node.override['audit']['profiles'] = { 'admin/myprofile' => true }
      runner.node.override['audit']['interval']['enabled'] = true
      runner.converge(described_recipe)
    end

    it 'does not fetch or execute on compliance profile' do
      expect(chef_run).to_not fetch_compliance_profile('myprofile')
      expect(chef_run).to_not execute_compliance_profile('myprofile')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
