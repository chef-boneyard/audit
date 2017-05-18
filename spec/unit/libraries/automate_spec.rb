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
require_relative '../../../libraries/reporters/automate'
require_relative '../../data/mock.rb'

describe 'Reporter::ChefAutomate methods' do
  before :each do
    entity_uuid = 'aaaaaaaa-709a-475d-bef5-zzzzzzzzzzzz'
    run_id = '3f0536f7-3361-4bca-ae53-b45118dceb5d'
    insecure = false
    @enriched_report_expected = {"version":"1.2.1",
      "profiles":
      [{"name":"tmp_compliance_profile",
        "title":"/tmp Compliance Profile",
        "summary":"An Example Compliance Profile",
        "version":"0.1.1",
        "maintainer":"Nathen Harvey <nharvey@chef.io>",
        "license":"Apache 2.0 License",
        "copyright":"Nathen Harvey <nharvey@chef.io>",
        "supports":[],
        "controls":
         [ {"title":"A /tmp directory must exist",
            "desc":"A /tmp directory must exist",
            "impact":0.3,
            "refs":[],
            "tags":{},
            "code":
              "control 'tmp-1.0' do\n  impact 0.3\n  title 'A /tmp directory must exist'\n  desc 'A /tmp directory must exist'\n  describe file '/tmp' do\n    it { should be_directory }\n  end\nend\n",
            "source_location":{"ref":"/Users/vjeffrey/code/delivery/insights/data_generator/chef-client/cache/cookbooks/test-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb", "line":3},
            "id":"tmp-1.0",
            "results":[{"status":"passed", "code_desc":"File /tmp should be directory", "run_time":0.002312, "start_time":"2016-10-19 11:09:43 -0400"}]},
           {"title":"/tmp directory is owned by the root user",
            "desc":"The /tmp directory must be owned by the root user",
            "impact":0.3,
            "refs":[{"url":"https://pages.chef.io/rs/255-VFB-268/images/compliance-at-velocity2015.pdf", "ref":"Compliance Whitepaper"}],
            "tags":{"production":nil, "development":nil, "identifier":"value", "remediation":"https://github.com/chef-cookbooks/audit"},
            "code":
              "control 'tmp-1.1' do\n  impact 0.3\n  title '/tmp directory is owned by the root user'\n  desc 'The /tmp directory must be owned by the root user'\n  tag 'production','development'\n  tag identifier: 'value'\n  tag remediation: 'https://github.com/chef-cookbooks/audit'\n  ref 'Compliance Whitepaper', url: 'https://pages.chef.io/rs/255-VFB-268/images/compliance-at-velocity2015.pdf'\n  describe file '/tmp' do\n    it { should be_owned_by 'root' }\n  end\nend\n",
            "source_location":{"ref":"/Users/vjeffrey/code/delivery/insights/data_generator/chef-client/cache/cookbooks/test-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb", "line":12},
            "id":"tmp-1.1",
            "results":[{"status":"passed", "code_desc":"File /tmp should be owned by \"root\"", "run_time":0.028845, "start_time":"2016-10-19 11:09:43 -0400"}]}],
        "groups":[{"title":"/tmp Compliance Profile", "controls":["tmp-1.0", "tmp-1.1"], "id":"controls/tmp.rb"}],
        "attributes":[{"name":"syslog_pkg", "options":{"default":"rsyslog", "description":"syslog package..."}}]}],
      "other_checks": [],
      "statistics":{"duration":0.032332},
      "type":"inspec_report",
      "node_name":"chef-client.solo",
      "end_time":"2016-07-19T19:19:19+01:00",
      "node_uuid":"aaaaaaaa-709a-475d-bef5-zzzzzzzzzzzz",
      "environment":"My Prod Env",
      "report_uuid":"3f0536f7-3361-4bca-ae53-b45118dceb5d"
      }

    opts = {
      entity_uuid: entity_uuid,
      run_id: run_id,
      node_info: MockData.node_info,
      insecure: insecure,
    }
    # set data_collector
    Chef::Config[:data_collector] = {token: 'dctoken', server_url: 'https://automate.test/data_collector' }
    stub_request(:post, 'https://automate.test/data_collector').
             with(:body => @enriched_report_expected.to_json,
                  :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'identity', 'Content-Length'=>/.+/, 'Content-Type'=>'application/json', 'Host'=>'automate.test', 'User-Agent'=>/.+/, 'X-Chef-Version'=>/.+/, 'X-Data-Collector-Auth'=>'version=1.0', 'X-Data-Collector-Token'=>'dctoken'}).
             to_return(:status => 200, :body => "", :headers => {})

    @automate = Reporter::ChefAutomate.new(opts)
  end

  it 'sends report successfully to ChefAutomate' do
    allow(DateTime).to receive(:now).and_return(DateTime.parse('2016-07-19T19:19:19+01:00'))
    expect(@automate.send_report(MockData.inspec_results)).to eq(true)
  end

  it 'enriches report correctly with the most test coverage' do
    allow(DateTime).to receive(:now).and_return(DateTime.parse('2016-07-19T19:19:19+01:00'))
    expect(@automate.enriched_report(MockData.inspec_results)).to eq(@enriched_report_expected)
  end

  it 'is not sending report when entity_uuid is missing' do
    opts = {
      entity_uuid: nil,
      run_id: '3f0536f7-3361-4bca-ae53-b45118dceb5d',
      node_info: MockData.node_info,
      insecure: false,
    }
    viz2 = Reporter::ChefAutomate.new(opts)
    expect(viz2.send_report(MockData.inspec_results)).to eq(false)
  end

end
