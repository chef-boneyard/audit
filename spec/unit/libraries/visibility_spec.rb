# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: visibility
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
require_relative '../../../libraries/collector_classes'
require_relative '../../data/mock.rb'

describe 'Collector::ChefVisibility methods' do
  before :each do
    entity_uuid = 'aaaaaaaa-709a-475d-bef5-zzzzzzzzzzzz'
    run_id = '3f0536f7-3361-4bca-ae53-b45118dceb5d'
    insecure = false
    report = MockData.inspec_results
    @enriched_report_expected =  "{\"profiles\":[{\"name\":\"tmp_compliance_profile\",\"title\":\"/tmp Compliance Profile\",\"summary\":\"An Example Compliance Profile\",\"version\":\"0.1.1\",\"maintainer\":\"Nathen Harvey <nharvey@chef.io>\",\"license\":\"Apache 2.0 License\",\"copyright\":\"Nathen Harvey <nharvey@chef.io>\",\"supports\":[],\"controls\":[{\"title\":\"A /tmp directory must exist\",\"desc\":\"A /tmp directory must exist\",\"impact\":0.3,\"refs\":[],\"tags\":{},\"code\":\"control 'tmp-1.0' do\\n  impact 0.3\\n  title 'A /tmp directory must exist'\\n  desc 'A /tmp directory must exist'\\n  describe file '/tmp' do\\n    it { should be_directory }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/Users/vjeffrey/code/delivery/insights/data_generator/chef-client/cache/cookbooks/test-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb\",\"line\":3},\"id\":\"tmp-1.0\",\"results\":[{\"status\":\"passed\",\"code_desc\":\"File /tmp should be directory\",\"run_time\":0.002312,\"start_time\":\"2016-10-19 11:09:43 -0400\"}]},{\"title\":\"/tmp directory is owned by the root user\",\"desc\":\"The /tmp directory must be owned by the root user\",\"impact\":0.3,\"refs\":[{\"url\":\"https://pages.chef.io/rs/255-VFB-268/images/compliance-at-velocity2015.pdf\",\"ref\":\"Compliance Whitepaper\"}],\"tags\":{\"production\":null,\"development\":null,\"identifier\":\"value\",\"remediation\":\"https://github.com/chef-cookbooks/audit\"},\"code\":\"control 'tmp-1.1' do\\n  impact 0.3\\n  title '/tmp directory is owned by the root user'\\n  desc 'The /tmp directory must be owned by the root user'\\n  tag 'production','development'\\n  tag identifier: 'value'\\n  tag remediation: 'https://github.com/chef-cookbooks/audit'\\n  ref 'Compliance Whitepaper', url: 'https://pages.chef.io/rs/255-VFB-268/images/compliance-at-velocity2015.pdf'\\n  describe file '/tmp' do\\n    it { should be_owned_by 'root' }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/Users/vjeffrey/code/delivery/insights/data_generator/chef-client/cache/cookbooks/test-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb\",\"line\":12},\"id\":\"tmp-1.1\",\"results\":[{\"status\":\"passed\",\"code_desc\":\"File /tmp should be owned by \\\"root\\\"\",\"run_time\":0.028845,\"start_time\":\"2016-10-19 11:09:43 -0400\"}]}],\"groups\":[{\"title\":\"/tmp Compliance Profile\",\"controls\":[\"tmp-1.0\",\"tmp-1.1\"],\"id\":\"controls/tmp.rb\"}],\"attributes\":[]}],\"event_type\":\"inspec\",\"event_action\":\"exec\",\"compliance_summary\":{\"total\":2,\"passed\":{\"total\":2},\"skipped\":{\"total\":0},\"failed\":{\"total\":0,\"minor\":0,\"major\":0,\"critical\":0},\"status\":\"passed\",\"node_name\":\"chef-client.solo\",\"end_time\":\"2016-07-19T19:19:19+01:00\",\"duration\":0.032332,\"inspec_version\":\"1.2.1\"},\"entity_uuid\":\"aaaaaaaa-709a-475d-bef5-zzzzzzzzzzzz\",\"run_id\":\"3f0536f7-3361-4bca-ae53-b45118dceb5d\"}"
    @viz = Collector::ChefVisibility.new(entity_uuid, run_id, MockData.node_info, insecure, report)
  end

  it 'returns the correct control status' do
    expect(@viz.control_status(nil)).to eq(nil)
    expect(@viz.control_status([{"status"=>"failed"}])).to eq('failed')
    expect(@viz.control_status([{"status"=>"passed"}])).to eq('passed')
    expect(@viz.control_status([{"status"=>"passed"},{"status"=>"failed"}])).to eq('failed')
    expect(@viz.control_status([{"status"=>"failed"},{"status"=>"passed"}])).to eq('failed')
    expect(@viz.control_status([{"status"=>"passed"},{"status"=>"skipped"}])).to eq('skipped')
    expect(@viz.control_status([{"status"=>"skipped"},{"status"=>"failed"}])).to eq('failed')
  end

  it 'reports impact criticality correctly' do
    expect(@viz.impact_to_s(0)).to eq('minor')
    expect(@viz.impact_to_s(0.1234)).to eq('minor')
    expect(@viz.impact_to_s(0.4)).to eq('major')
    expect(@viz.impact_to_s(0.69)).to eq('major')
    expect(@viz.impact_to_s(0.7)).to eq('critical')
    expect(@viz.impact_to_s(1.0)).to eq('critical')
  end

  it 'reports compliance status like a compliance officer' do
    passed = {"total"=>5, "passed"=>{"total"=>3}, "skipped"=>{"total"=>2}, "failed"=>{"total"=>0, "minor"=>0, "major"=>0, "critical"=>0}}
    failed = {"total"=>5, "passed"=>{"total"=>1}, "skipped"=>{"total"=>1}, "failed"=>{"total"=>3, "minor"=>1, "major"=>1, "critical"=>1}}
    skipped = {"total"=>5, "passed"=>{"total"=>0}, "skipped"=>{"total"=>5}, "failed"=>{"total"=>0, "minor"=>0, "major"=>0, "critical"=>0}}
    expect(@viz.compliance_status(nil)).to eq('unknown')
    expect(@viz.compliance_status(failed)).to eq('failed')
    expect(@viz.compliance_status(passed)).to eq('passed')
    expect(@viz.compliance_status(skipped)).to eq('skipped')
  end

  it 'counts controls like an accountant' do
    profi = [{"name"=>"test-profile",
              "controls"=>
              [{"id"=>"Checking /etc/missing1.rb existance",
                "impact"=>0,
                "results"=>[{"status"=>"failed"}]},
              {"id"=>"Checking /etc/missing2.rb existance",
                "impact"=>0.5,
                "results"=>[{"status"=>"failed"}]},
              {"id"=>"Checking /etc/missing3.rb existance",
                "impact"=>0.8,
                "results"=>[{"status"=>"failed"}]},
              {"id"=>"Checking /etc/passwd existance",
                "impact"=>0.88,
                "results"=>[{"status"=>"passed"}]},
              {"id"=>"Checking /etc/something existance",
                "impact"=>1.0,
                "results"=>[{"status"=>"skipped"}]}]
    }]
    expected_count = {"total"=>5, "passed"=>{"total"=>1}, "skipped"=>{"total"=>1}, "failed"=>{"total"=>3, "minor"=>1, "major"=>1, "critical"=>1}}
    expect(@viz.count_controls(profi)).to eq(expected_count)
  end

  it 'enriches report correctly with the most test coverage' do
    allow(DateTime).to receive(:now).and_return(DateTime.parse('2016-07-19T19:19:19+01:00'))
    expect(@viz.enriched_report(JSON.parse(MockData.inspec_results))).to eq(@enriched_report_expected)
  end

  it 'is not sending report when entity_uuid is missing' do
    entity_uuid = nil
    run_id = '3f0536f7-3361-4bca-ae53-b45118dceb5d'
    insecure = false
    viz2 = Collector::ChefVisibility.new(entity_uuid, run_id, {}, insecure, MockData.inspec_results)
    expect(viz2.send_report).to eq(false)
  end
end
