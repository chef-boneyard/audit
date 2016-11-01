# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: compliance

require 'spec_helper'
require_relative '../../../libraries/collector_classes'

describe 'Collector::ChefCompliance methods' do
  before :each do
  require 'bundles/inspec-compliance/configuration'
    url = 'https://192.168.33.201/api'
    node_info = {:node=>"default-ubuntu-1404", :os=>{:release=>"14.04", :family=>"ubuntu"}, :environment=>"_default"}
    raise_if_unreachable = true
    @report = {"version"=>"1.2.1", "controls"=>[{"id"=>"basic-4", "status"=>"passed", "code_desc"=>"File /etc/ssh/sshd_config should be owned by \"root\"", "profile_id"=>"ssh"}], "statistics"=>{"duration"=>0.355784812}}
    compliance_profiles = [{:owner=> 'admin', :profile_id=> 'ssh'}]
    @enriched_report_expected = "{\"node\":\"default-ubuntu-1404\",\"os\":{\"release\":\"14.04\",\"family\":\"ubuntu\"},\"environment\":\"_default\",\"reports\":{\"ssh\":{\"version\":\"1.2.1\",\"controls\":[{\"id\":\"basic-4\",\"status\":\"passed\",\"code_desc\":\"File \/etc\/ssh\/sshd_config should be owned by \\\"root\\\"\",\"profile_id\":\"ssh\"}],\"statistics\":{\"duration\":0.355784812}}},\"profiles\":{\"ssh\":\"admin\"}}"
    @chef_compliance = Collector::ChefCompliance.new(url, node_info, raise_if_unreachable, compliance_profiles, @report)
  end

  it 'enriches the report correctly' do
    expect(@chef_compliance.enriched_report(@report)).to eq(@enriched_report_expected)
  end
end