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
require_relative '../../../libraries/collector_classes'
require_relative '../../data/mock.rb'

describe 'Collector::ChefVisibility methods' do
  before :each do
    entity_uuid = 'aaaaaaaa-709a-475d-bef5-zzzzzzzzzzzz'
    run_id = '3f0536f7-3361-4bca-ae53-b45118dceb5d'
    @enriched_report_expected = "{\"profiles\":[{\"name\":\"mylinux-failure-success\",\"title\":\"Mylinux Failure Success\",\"maintainer\":\"Chef Software, Inc.\",\"copyright\":\"Chef Software, Inc.\",\"copyright_email\":\"support@chef.io\",\"license\":\"Apache 2 license\",\"summary\":\"Demonstrates the use of InSpec Compliance Profile\",\"version\":\"2.7.0\",\"supports\":[{\"os-family\":\"unix\"}],\"controls\":[{\"title\":\"Check /etc/missing2.rb\",\"desc\":\"File test in failure-success.rb\",\"impact\":0.0,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/missing2.rb existance' do\\n  impact 0\\n  title \\\"Check /etc/missing2.rb\\\"\\n  desc \\\"File test in failure-success.rb\\\"\\n  describe file('/etc/missing2.rb') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb\",\"line\":2},\"results\":[{\"status\":\"failed\",\"code_desc\":\"File /etc/missing2.rb should be file\",\"run_time\":0.004004,\"start_time\":\"2016-07-19 07:50:54 +0100\",\"message\":\"expected `File /etc/missing2.rb.file?` to return true, got false\"}],\"id\":\"Checking /etc/missing2.rb existance\"},{\"title\":\"Check /etc/missing4.rb\",\"desc\":\"File test in failure-success.rb\",\"impact\":0.22,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/missing4.rb existance' do\\n  impact 0.22\\n  title \\\"Check /etc/missing4.rb\\\"\\n  desc \\\"File test in failure-success.rb\\\"\\n  describe file('/etc/missing4.rb') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb\",\"line\":11},\"results\":[{\"status\":\"failed\",\"code_desc\":\"File /etc/missing4.rb should be file\",\"run_time\":0.000206,\"start_time\":\"2016-07-19 07:50:54 +0100\",\"message\":\"expected `File /etc/missing4.rb.file?` to return true, got false\"}],\"id\":\"Checking /etc/missing4.rb existance\"},{\"title\":\"Check /etc/missing5.rb\",\"desc\":\"File test in failure-success.rb\",\"impact\":0.5,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/missing5.rb existance' do\\n  impact 0.5\\n  title \\\"Check /etc/missing5.rb\\\"\\n  desc \\\"File test in failure-success.rb\\\"\\n  describe file('/etc/missing5.rb') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb\",\"line\":20},\"results\":[{\"status\":\"failed\",\"code_desc\":\"File /etc/missing5.rb should be file\",\"run_time\":0.000125,\"start_time\":\"2016-07-19 07:50:54 +0100\",\"message\":\"expected `File /etc/missing5.rb.file?` to return true, got false\"}],\"id\":\"Checking /etc/missing5.rb existance\"},{\"title\":\"Check /etc/missing6.rb\",\"desc\":\"File test in failure-success.rb\",\"impact\":0.6,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/missing6.rb existance' do\\n  impact 0.6\\n  title \\\"Check /etc/missing6.rb\\\"\\n  desc \\\"File test in failure-success.rb\\\"\\n  describe file('/etc/missing6.rb') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb\",\"line\":29},\"results\":[{\"status\":\"failed\",\"code_desc\":\"File /etc/missing6.rb should be file\",\"run_time\":0.000157,\"start_time\":\"2016-07-19 07:50:54 +0100\",\"message\":\"expected `File /etc/missing6.rb.file?` to return true, got false\"}],\"id\":\"Checking /etc/missing6.rb existance\"},{\"title\":\"Check /etc/missing7.rb\",\"desc\":\"File test in failure-success.rb\",\"impact\":0.05,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/missing7.rb existance' do\\n  impact 0.05\\n  title \\\"Check /etc/missing7.rb\\\"\\n  desc \\\"File test in failure-success.rb\\\"\\n  describe file('/etc/missing7.rb') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb\",\"line\":38},\"results\":[{\"status\":\"failed\",\"code_desc\":\"File /etc/missing7.rb should be file\",\"run_time\":0.000239,\"start_time\":\"2016-07-19 07:50:54 +0100\",\"message\":\"expected `File /etc/missing7.rb.file?` to return true, got false\"}],\"id\":\"Checking /etc/missing7.rb existance\"},{\"title\":\"Check /etc/group\",\"desc\":\"File test in failure-success.rb\",\"impact\":1.0,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/group existance' do\\n  impact 1\\n  title \\\"Check /etc/group\\\"\\n  desc \\\"File test in failure-success.rb\\\"\\n  describe file('/etc/group') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb\",\"line\":47},\"results\":[{\"status\":\"passed\",\"code_desc\":\"File /etc/group should be file\",\"run_time\":0.000224,\"start_time\":\"2016-07-19 07:50:54 +0100\"}],\"id\":\"Checking /etc/group existance\"},{\"title\":\"Check /etc/missing3.rb\",\"desc\":\"File test in failure.rb\",\"impact\":0.7,\"refs\":[],\"tags\":{},\"code\":\"control 'Checking /etc/missing3.rb' do\\n  impact 0.7\\n  title \\\"Check /etc/missing3.rb\\\"\\n  desc \\\"File test in failure.rb\\\"\\n  describe file('/etc/missing3.rb') do\\n    it { should be_file }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure.rb\",\"line\":2},\"results\":[{\"status\":\"failed\",\"code_desc\":\"File /etc/missing3.rb should be file\",\"run_time\":0.00021,\"start_time\":\"2016-07-19 07:50:54 +0100\",\"message\":\"expected `File /etc/missing3.rb.file?` to return true, got false\"}],\"id\":\"Checking /etc/missing3.rb\"},{\"title\":\"Control used to test skipped group\",\"desc\":null,\"impact\":0.45,\"refs\":[],\"tags\":{},\"code\":\"control 'control-1 guarded by only_if' do\\n  impact 0.45\\n  title 'Control used to test skipped group'\\n  describe command('missing-command') do\\n    its('stdout') { should_not match(/^bingo/) }\\n  end\\n  describe command('missing-command-2') do\\n    its('stdout') { should_not match(/^bingo/) }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/skipped.rb\",\"line\":6},\"results\":[{\"status\":\"skipped\",\"code_desc\":\"Operating System Detection Skipped control due to only_if condition.\",\"skip_message\":\"Skipped control due to only_if condition.\",\"resource\":\"Operating System Detection\",\"run_time\":1.5e-05,\"start_time\":\"2016-07-19 07:50:54 +0100\"}],\"id\":\"control-1 guarded by only_if\"},{\"title\":\"Control used to test skipped group\",\"desc\":null,\"impact\":0.15,\"refs\":[],\"tags\":{},\"code\":\"control 'control-2 guarded by only_if' do\\n  impact 0.15\\n  title 'Control used to test skipped group'\\n  describe command('missing-command-3') do\\n    its('stdout') { should_not match(/^bingo/) }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/skipped.rb\",\"line\":17},\"results\":[{\"status\":\"skipped\",\"code_desc\":\"Operating System Detection Skipped control due to only_if condition.\",\"skip_message\":\"Skipped control due to only_if condition.\",\"resource\":\"Operating System Detection\",\"run_time\":7.0e-06,\"start_time\":\"2016-07-19 07:50:54 +0100\"}],\"id\":\"control-2 guarded by only_if\"}],\"groups\":[{\"title\":null,\"controls\":[\"Checking /etc/missing2.rb existance\",\"Checking /etc/missing4.rb existance\",\"Checking /etc/missing5.rb existance\",\"Checking /etc/missing6.rb existance\",\"Checking /etc/missing7.rb existance\",\"Checking /etc/group existance\"],\"id\":\"controls/failure-success.rb\"},{\"title\":null,\"controls\":[\"Checking /etc/missing3.rb\"],\"id\":\"controls/failure.rb\"},{\"title\":\"Title for skipped.rb\",\"controls\":[\"control-1 guarded by only_if\",\"control-2 guarded by only_if\"],\"id\":\"controls/skipped.rb\"}],\"attributes\":[]},{\"name\":\"tmp_compliance_profile\",\"title\":\"/tmp Compliance Profile\",\"summary\":\"An Example Compliance Profile\",\"version\":\"0.1.1\",\"maintainer\":\"Someone <someone@example.com>\",\"license\":\"Apache 2.0 License\",\"copyright\":\"Someone <someone@example.com>\",\"supports\":[],\"controls\":[{\"title\":\"A /tmp directory must exist\",\"desc\":\"A /tmp directory must exist\",\"impact\":0.3,\"refs\":[],\"tags\":{},\"code\":\"control 'tmp-1.0' do\\n  impact 0.3\\n  title 'A /tmp directory must exist'\\n  desc 'A /tmp directory must exist'\\n  describe file '/tmp' do\\n    it { should be_directory }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb\",\"line\":3},\"results\":[{\"status\":\"passed\",\"code_desc\":\"File /tmp should be directory\",\"run_time\":0.000286,\"start_time\":\"2016-07-19 07:50:54 +0100\"}],\"id\":\"tmp-1.0\"},{\"title\":\"/tmp directory is owned by the root user\",\"desc\":\"The /tmp directory must be owned by the root user\",\"impact\":0.3,\"refs\":[],\"tags\":{},\"code\":\"control 'tmp-1.1' do\\n  impact 0.3\\n  title '/tmp directory is owned by the root user'\\n  desc 'The /tmp directory must be owned by the root user'\\n  describe file '/tmp' do\\n    it { should be_owned_by 'root' }\\n  end\\nend\\n\",\"source_location\":{\"ref\":\"/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb\",\"line\":12},\"results\":[{\"status\":\"passed\",\"code_desc\":\"File /tmp should be owned by \\\"root\\\"\",\"run_time\":0.021412,\"start_time\":\"2016-07-19 07:50:54 +0100\"}],\"id\":\"tmp-1.1\"}],\"groups\":[{\"title\":\"/tmp Compliance Profile\",\"controls\":[\"tmp-1.0\",\"tmp-1.1\"],\"id\":\"controls/tmp.rb\"}],\"attributes\":[]}],\"event_type\":\"inspec\",\"event_action\":\"exec\",\"compliance_summary\":{\"total\":11,\"passed\":{\"total\":3},\"skipped\":{\"total\":2},\"failed\":{\"total\":6,\"minor\":3,\"major\":2,\"critical\":1},\"status\":\"failed\",\"node_name\":\"chef-client.solo\",\"end_time\":\"2016-07-19T19:19:19+01:00\",\"duration\":0.028877,\"inspec_version\":\"0.27.1\"},\"entity_uuid\":\"aaaaaaaa-709a-475d-bef5-zzzzzzzzzzzz\",\"run_id\":\"3f0536f7-3361-4bca-ae53-b45118dceb5d\"}"
    @viz = Collector::ChefVisibility.new(entity_uuid, run_id, MockData.chef_client_report)
  end

  it 'converts hashes to arrays correctly' do
    got_hash = {'a1'=>{'a2'=>'a3'},'b1'=>{'b2'=>'b3'}}
    expected_array = [{'id'=>'a1','a2'=>'a3'},{'id'=>'b1','b2'=>'b3'}]
    expect(@viz.hash_to_array(got_hash)).to eq(expected_array)
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
    expect(@viz.enriched_report).to eq(@enriched_report_expected)
  end

  it 'is not sending report when entity_uuid is missing' do
    entity_uuid = nil
    run_id = '3f0536f7-3361-4bca-ae53-b45118dceb5d'
    viz2 = Collector::ChefVisibility.new(entity_uuid, run_id, {})
    expect(viz2.send_report).to eq(false)
  end
end
