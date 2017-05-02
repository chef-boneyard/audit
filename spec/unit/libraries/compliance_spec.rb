# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: compliance_spec

require 'spec_helper'
require_relative '../../../libraries/reporters/compliance'

describe 'Reporter::ChefCompliance methods' do
  before :each do
  require 'bundles/inspec-compliance/configuration'
    url = 'https://192.168.33.201/api/owners/admin/inspec'
    node_info = {:node=>"default-ubuntu-1404", :os=>{:release=>"14.04", :family=>"ubuntu"}, :environment=>"_default"}
    raise_if_unreachable = true
    @report = {
      "version"=>"1.2.1",
      "controls"=>[{"id"=>"basic-4", "status"=>"passed", "code_desc"=>"File /etc/ssh/sshd_config should be owned by \"root\"", "profile_id"=>"ssh"}], "statistics"=>{"duration"=>0.355784812}
    }
    compliance_profiles = [{:owner=> 'admin', :profile_id=> 'ssh'}]
    @enriched_report_expected = {
      "node"=>"default-ubuntu-1404",
      "os"=>{"release"=>"14.04", "family"=>"ubuntu"},
      "environment"=>"_default",
      "reports"=>{"ssh"=>{"version"=>"1.2.1", "controls"=>[{"id"=>"basic-4", "status"=>"passed", "code_desc"=>"File /etc/ssh/sshd_config should be owned by \"root\"", "profile_id"=>"ssh"}], "statistics"=>{"duration"=>0.355784812}}},
      "profiles"=>{"ssh"=>"admin"}
    }

    opts = {
      url: url,
      node_info: node_info,
      raise_if_unreachable: raise_if_unreachable,
      compliance_profiles: compliance_profiles,
      token: 1234
    }

    @chef_compliance = Reporter::ChefCompliance.new(opts)

    stub_request(:post, url).
       with(:body => @enriched_report_expected.to_json,
            :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer 1234', 'User-Agent'=>/.+/}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it 'sends report successfully' do
    expect(@chef_compliance.send_report(@report)).to eq(true)
  end

  it 'enriches the report correctly' do
    expect(JSON.parse(@chef_compliance.enriched_report(@report))).to eq(@enriched_report_expected)
  end
end
