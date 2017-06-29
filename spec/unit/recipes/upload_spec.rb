# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: upload
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

describe 'audit::upload' do
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
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9') do |node|
        node.override['audit']['collector'] = 'chef-compliance'
        node.override['audit']['profiles'] = [ {'name': 'admin/myprofile', 'path': '/some/path.tar.gz' } ]
        node.override['audit']['server'] = 'https://my.compliance.test/api'
        node.override['audit']['refresh_token'] = 'abcdefg'
        node.override['audit']['insecure'] = true
        node.override['audit']['owner'] = 'admin'
      end.converge(described_recipe)
    end

    it 'uploads compliance_profile[myprofile]' do
      expect(chef_run).to upload_compliance_profile('myprofile').with(
        server: 'https://my.compliance.test/api',
        owner: 'admin',
        path: '/some/path.tar.gz',
        insecure: true,
        overwrite: true
      )
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
