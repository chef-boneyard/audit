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

    it 'updates inspec to the appropriate version' do
      expect(chef_run).to install_chef_gem('inspec').with(version: '0.22.1')
    end

    it 'creates a compliance cache directory' do
      expect(chef_run).to create_directory(::File.join(Chef::Config[:file_cache_path], 'compliance'))
    end

    it 'creates a handlers directory' do
      expect(chef_run).to create_directory(::File.join(Chef::Config[:file_cache_path], 'handler'))
    end

    it 'puts the handler in the handlers directory' do
      expect(chef_run).to create_cookbook_file(::File.join(Chef::Config[:file_cache_path], 'handler', 'audit_report.rb'))
    end

    it 'sets up the chef_handler to run' do
      expect(chef_run).to enable_chef_handler('Chef::Handler::AuditReport')
    end
  end
end
