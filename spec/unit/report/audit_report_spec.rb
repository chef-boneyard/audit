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
require_relative '../../../files/default/audit_report'
require_relative '../../data/mock.rb'

describe 'Chef::Handler::AuditReport methods' do
  before :each do
    @audit_report = Chef::Handler::AuditReport.new()
    @interval = 1440
    @interval_time = 1440
    @report_file = File.new("./mock_file.json", "w")
  end

  describe 'report when interval settings are set to default (disabled)' do
    interval_enabled = false

    it 'returns true for check_interval_settings' do
      status = @audit_report.check_interval_settings(@interval, interval_enabled, @interval_time, @report_file)
      expect(status).to eq(true)
      File.delete("./mock_file.json")
    end
  end

  describe 'report when interval settings are enabled' do
    interval_enabled = true

    it 'returns false for check_interval_settings' do
      status = @audit_report.check_interval_settings(@interval, interval_enabled, @interval_time, @report_file)
      expect(status).to eq(false)
      File.delete("./mock_file.json")
    end
  end
end


