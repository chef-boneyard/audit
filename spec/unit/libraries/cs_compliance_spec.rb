# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: cs_compliance_spec

require 'spec_helper'
require_relative '../../../libraries/reporters/cs_compliance'

describe 'Reporter::ChefServerCompliance methods' do
  before :each do
  require 'bundles/inspec-compliance/configuration'
    url = 'https://chef-server/compliance/inspec'
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

    Chef::Config[:client_key] = File.expand_path("../../chef-client.pem", File.dirname(__FILE__))
    Chef::Config[:node_name] = 'spec-node'

    stub_request(:post, url).
       with(:body => @enriched_report_expected.to_json,
       :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'336', 'Content-Type'=>'application/json', 'Host'=>/.+/, 'User-Agent'=>/.+/, 'X-Chef-Version'=>/.+/, 'X-Ops-Authorization-1'=>/.+/, 'X-Ops-Authorization-2'=>/.+/, 'X-Ops-Authorization-3'=>/.+/, 'X-Ops-Authorization-4'=>/.+/, 'X-Ops-Authorization-5'=>/.+/, 'X-Ops-Authorization-6'=>/.+/, 'X-Ops-Content-Hash'=>/.+/, 'X-Ops-Server-Api-Version'=>'1', 'X-Ops-Sign'=>'algorithm=sha1;version=1.1;', 'X-Ops-Timestamp'=>/.+/, 'X-Ops-Userid'=>'spec-node', 'X-Remote-Request-Id'=>/.+/}).
       to_return(:status => 200, :body => "", :headers => {})

    @chef_compliance = Reporter::ChefServerCompliance.new(opts)
  end

  it 'sends report successfully' do
    expect(@chef_compliance.send_report(@report)).to eq(true)
  end
end
