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

    it 'installs the inspec gem' do
      expect(chef_run).to install_inspec_gem('inspec')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end


  context 'When an inspec gem version is specified ' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9') do |node|
        node.override['audit']['inspec_version'] = '0.0.0'
      end.converge(described_recipe)
    end

    it 'installs the inspec gem with the correct version' do
      expect(chef_run).to install_inspec_gem('inspec').with(version: '0.0.0')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When an inspec gem alternate source is specified ' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9') do |node|
        node.override['audit']['inspec_gem_source'] = 'http://0.0.0.0:8080'
      end.converge(described_recipe)
    end

    it 'installs the inspec gem from the alternate source' do
      expect(chef_run).to install_inspec_gem('inspec').with(source: 'http://0.0.0.0:8080')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When server and refresh_token are specified' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9') do |node|
        node.override['audit']['collector'] = 'chef-compliance'
        node.override['audit']['profiles'] = [ { 'name': 'myprofile', 'compliance': 'admin/myprofile' } ]
        node.override['audit']['server'] = 'https://my.compliance.test/api'
        node.override['audit']['refresh_token'] = 'abcdefg'
        node.override['audit']['insecure'] = true
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When two profiles are specified' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.node.override['audit']['profiles'] = [ { 'name': 'myprofile', 'compliance': 'admin/myprofile' }, { 'name': 'ssh', 'compliance': 'base/ssh' } ]
      runner.node.override['audit']['inspec_version'] = 'latest'
      runner.node.override['audit']['quiet'] = true
      runner.converge(described_recipe)
    end
    let(:myprofile) { chef_run.compliance_profile('myprofile') }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  # TODO: need to implement functionality for this
  # context 'When invalid profile is passed' do
  #   let(:chef_run) do
  #     runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
  #     runner.node.override['audit']['profiles'] = [ { 'name': 'myprofile', 'compliance': 'myprofile' } ]
  #     runner.converge(described_recipe)
  #   end

  #   it 'does raise an error' do
  #     expect { chef_run }.to raise_error("Invalid profile name 'myprofile'. Must contain /, e.g. 'john/ssh'")
  #   end
  # end

  context 'When specifying profiles with alternate sources' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.node.override['audit']['profiles'] = [
        { 'name': 'linux', 'compliance': 'base/linux' },
        { 'name': 'apache', 'compliance': 'base/apache' },
        { 'name': 'ssh-hardening', 'supermarket': 'hardening/ssh-hardening' },
        { 'name': 'brewinc/tmp_compliance_profile',
          'url': 'https://github.com/nathenharvey/tmp_compliance_profile'
        },
        { 'name': 'brewinc/tmp_compliance_profile-master',
          'path': '/tmp/tmp_compliance_profile-master'
        }
      ]
      runner.converge(described_recipe)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When specifying a single reporter' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.node.override['audit']['collector'] = 'json-file'
      runner.node.override['audit']['profiles'] = [
        { 'name': 'linux', 'compliance': 'base/linux' },
        { 'name': 'apache', 'compliance': 'base/apache' },
        { 'name': 'ssh-hardening', 'supermarket': 'hardening/ssh-hardening' },
        { 'name': 'brewinc/tmp_compliance_profile',
          'url': 'https://github.com/nathenharvey/tmp_compliance_profile'
        },
        { 'name': 'brewinc/tmp_compliance_profile-master',
          'path': '/tmp/tmp_compliance_profile-master'
        }
      ]
      runner.converge(described_recipe)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When specifying multiple reporters' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.node.override['audit']['collector'] = ['chef-compliance', 'json-file']
      runner.node.override['audit']['profiles'] = [
        { 'name': 'linux', 'compliance': 'base/linux' },
        { 'name': 'apache', 'compliance': 'base/apache' },
        { 'name': 'ssh-hardening', 'supermarket': 'hardening/ssh-hardening' },
        { 'name': 'brewinc/tmp_compliance_profile',
          'url': 'https://github.com/nathenharvey/tmp_compliance_profile'
        },
        { 'name': 'brewinc/tmp_compliance_profile-master',
          'path': '/tmp/tmp_compliance_profile-master'
        }
      ]
      runner.converge(described_recipe)
    end
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'when audit_mode is enabled' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9')
      runner.node.override['audit']['collector'] = 'json-file'
      runner.node.override['audit']['profiles'] = [
        { 'name': 'linux', 'compliance': 'base/linux' },
      ]
      Chef::Config[:audit_mode] = :enabled
      runner.converge(described_recipe)
    end

    it 'raises an exception' do
      expect { chef_run }.to raise_error(RuntimeError)
    end
  end
end
