# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: automate_spec
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
require_relative '../../../libraries/reporters/audit-enforcer'

describe 'Reporter::ChefAutomate methods' do
  before :each do
    @min_report = {
      "profiles": [
        {
          "controls": [
            { "id": "c1", "results": [{ "status": 'passed' }] },
            { "id": "c2", "results": [{ "status": 'passed' }] },
          ],
        },
      ],
    }
    @automate = Reporter::AuditEnforcer.new()
  end

  it 'is not raising error for a successful InSpec report' do
    expect(@automate.send_report(@min_report)).to eq(true)
  end

  it 'is not raising error for an InSpec report with no controls' do
    expect(@automate.send_report({"profiles": [{"name": "empty"}]})).to eq(true)
  end

  it 'is not raising error for an InSpec report with controls but no results' do
    expect(@automate.send_report({"profiles": [{ "controls": [{"id": "empty"}]}]})).to eq(true)
  end

  it 'raises an error for a failed InSpec report' do
    @min_report[:profiles][0][:controls][1][:results][0][:status] = 'failed'
    expect{ @automate.send_report(@min_report) }.to raise_error('Audit c2 has failed. Aborting chef-client run.')
  end
end
