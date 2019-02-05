# encoding: utf-8
#
# Cookbook Name:: audit
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
require 'json'
require_relative '../../../libraries/helper'
require_relative '../../../files/default/handler/audit_report'
require_relative '../../data/mock.rb'

describe 'Chef::Handler::AuditReport methods' do
  let(:mynode) { Chef::Node.new }

  def set_inspec_backend_cache(status = false)
    mynode.default['audit']['inspec_backend_cache'] = status
    allow(@audit_report).to receive(:node).and_return(mynode)
  end

  before :each do
    @audit_report = Chef::Handler::AuditReport.new
  end

  describe ReportHelpers do
    let(:helpers) { Class.new { extend ReportHelpers } }
    before :each do
      @interval = 1440
      @interval_time = 1440
      interval_enabled = true
      write_to_file = false
      @helpers.create_timestamp_file
    end

    describe 'report when interval settings are set to default (disabled)' do
      interval_enabled = false

      it 'returns true for check_interval_settings' do
        status = @audit_report.check_interval_settings(@interval, interval_enabled, @interval_time)
        expect(status).to eq(true)
      end
    end

    describe 'report when interval settings are enabled' do
      interval_enabled = true

      it 'returns false for check_interval_settings' do
        status = @audit_report.check_interval_settings(@interval, interval_enabled, @interval_time)
        expect(status).to eq(false)
      end
    end
  end

  describe 'validate_inspec_version method' do
    before :each do
      require 'inspec'
    end

    it 'inspec min version fail' do
      stub_const('Inspec::VERSION', '1.20.0')
      expect { @audit_report.validate_inspec_version }
        .to raise_error(RuntimeError)
        .with_message('This audit cookbook version requires InSpec 1.25.1 or newer, aborting compliance scan...')
    end
    it 'inspec version warn for backend_cache' do
      stub_const('Inspec::VERSION', '1.46.0')
      set_inspec_backend_cache(true)
      expect(Chef::Log).to receive(:warn)
        .with('inspec_backend_cache requires InSpec version >= 1.47.0')
        .and_return('captured')
      expect(@audit_report.validate_inspec_version).to eq('captured')
    end
    it 'inspec version passes all requirements' do
      stub_const('Inspec::VERSION', '1.47.0')
      set_inspec_backend_cache(true)
      expect(Chef::Log).to_not receive(:warn)
      expect { @audit_report.validate_inspec_version }.to_not raise_error
    end
  end

  describe 'get_opts method' do
    it 'sets the format to json-min' do
      format = 'json-min'
      quiet = true
      set_inspec_backend_cache(true)
      opts = @audit_report.get_opts(format, quiet, {})
      expect(opts['report']).to be true
      expect(opts['format']).to eq('json-min')
      expect(opts['output']).to eq('/dev/null')
      expect(opts['logger']).to eq(Chef::Log)
      expect(opts[:backend_cache]).to be true
      expect(opts[:attributes].empty?).to be true
    end
    it 'sets the format to json' do
      format = 'json'
      quiet = true
      set_inspec_backend_cache(true)
      opts = @audit_report.get_opts(format, quiet, {})
      expect(opts['report']).to be true
      expect(opts['format']).to eq('json')
      expect(opts['output']).to eq('/dev/null')
      expect(opts['logger']).to eq(Chef::Log)
      expect(opts[:backend_cache]).to be true
      expect(opts[:attributes].empty?).to be true
    end
    it 'sets the backend_cache to false' do
      format = 'json'
      quiet = true
      set_inspec_backend_cache(false)
      opts = @audit_report.get_opts(format, quiet, {})
      expect(opts['report']).to be true
      expect(opts['format']).to eq('json')
      expect(opts['output']).to eq('/dev/null')
      expect(opts['logger']).to eq(Chef::Log)
      expect(opts[:backend_cache]).to be false
      expect(opts[:attributes].empty?).to be true
    end
    it 'sets the attributes' do
      format = 'json-min'
      quiet = true
      attributes = {
        first: 'value1',
        second: 'value2',
      }
      set_inspec_backend_cache(true)
      opts = @audit_report.get_opts(format, quiet, attributes)
      expect(opts[:attributes][:first]).to eq('value1')
      expect(opts[:attributes][:second]).to eq('value2')
    end
  end

  describe 'call' do
    it 'given a profile, returns a json report' do
      opts = { 'report' => true, 'format' => 'json', 'output' => '/dev/null' }
      path = File.expand_path('../../../data/mock_profile.rb', __FILE__)
      profiles = [{ 'name': 'example', 'path': path }]
      # we cirumwent the default load mechanisms, therefore we have to require inspec
      require 'inspec'
      report = @audit_report.call(opts, profiles)
      expected_report = /^.*version.*profiles.*controls.*statistics.*duration.*/
      expect(report.to_json).to match(expected_report)
    end
    it 'given a profile, returns a json-min report' do
      require 'inspec'
      opts = { 'report' => true, 'format' => 'json-min', 'output' => '/dev/null' }
      path = File.expand_path('../../../data/mock_profile.rb', __FILE__)
      profiles = [{ 'name': 'example', 'path': path }]
      # we cirumwent the default load mechanisms, therefore we have to require inspec
      require 'inspec'
      report = @audit_report.call(opts, profiles)
      expect(report[:controls].length).to eq(2)
    end
  end
end
