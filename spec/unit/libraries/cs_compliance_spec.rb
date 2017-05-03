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
      "version":"1.21.0",
      "profiles":[{
        "name":"tmp_compliance_profile",
        "title":"/tmp Compliance Profile",
        "summary":"An Example Compliance Profile",
        "version":"0.1.1",
        "maintainer":"Nathen Harvey <nharvey@chef.io>",
        "license":"Apache 2.0 License",
        "copyright":"Nathen Harvey <nharvey@chef.io>",
        "supports":[],
        "controls":[{
          "title":"A /tmp directory must exist",
          "desc":"A /tmp directory must exist",
          "impact":0.3,"refs":[],"tags":{},"code":"",
          "source_location":{"ref":"tmp_compliance_profile-master/controls/tmp.rb","line":3},
          "id":"tmp-1.0",
          "results":[{"status":"passed","code_desc":"File /tmp should be directory","run_time":0.001562,"start_time":"2017-05-02 21:23:03 +0200"}]
        },{
          "title":"/tmp directory is owned by the root user",
          "desc":"The /tmp directory must be owned by the root user",
          "impact":0.3,"refs":[],"tags":{},"code":"",
          "source_location":{"ref":"tmp_compliance_profile-master/controls/tmp.rb","line":12},
          "id":"tmp-1.1",
          "results":[{"status":"passed","code_desc":"File /tmp should be owned by \"root\"","run_time":0.023661,"start_time":"2017-05-02 21:23:03 +0200"}]
        }],
        "groups":[{
          "title":"/tmp Compliance Profile",
          "controls":["tmp-1.0","tmp-1.1"],
          "id":"controls/tmp.rb"}],
          "attributes":[]
        }],
        "statistics":{"duration":0.028643}
    }
    @source_location = [{
      "name": "tmp_compliance_profile",
      "compliance": "admin/tmp_compliance_profile"
    }]
    @enriched_report_expected = {
      "node": "default-ubuntu-1404",
      "os": {"release": "14.04", "family": "ubuntu"},
      "environment": "_default",
      "reports": {"tmp_compliance_profile": {
        "version": "1.21.0",
        "controls": [{"id": "tmp-1.0","profile_id": "tmp_compliance_profile","status": "passed","code_desc": "File /tmp should be directory"},{"id": "tmp-1.1","profile_id": "tmp_compliance_profile","status": "passed","code_desc": "File /tmp should be owned by \"root\""}],
        "statistics":  {"duration": 0.028643}
        }},
      "profiles": {"tmp_compliance_profile"=>"admin"}
    }

    opts = {
      url: url,
      node_info: node_info,
      raise_if_unreachable: raise_if_unreachable,
      token: 1234,
      source_location: @source_location
    }

    Chef::Config[:client_key] = File.expand_path("../../chef-client.pem", File.dirname(__FILE__))
    Chef::Config[:node_name] = 'spec-node'

    stub_request(:post, url).
       with(:body => @enriched_report_expected.to_json,
       :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>/.+/, 'Content-Type'=>'application/json', 'Host'=>/.+/, 'User-Agent'=>/.+/, 'X-Chef-Version'=>/.+/, 'X-Ops-Authorization-1'=>/.+/, 'X-Ops-Authorization-2'=>/.+/, 'X-Ops-Authorization-3'=>/.+/, 'X-Ops-Authorization-4'=>/.+/, 'X-Ops-Authorization-5'=>/.+/, 'X-Ops-Authorization-6'=>/.+/, 'X-Ops-Content-Hash'=>/.+/, 'X-Ops-Server-Api-Version'=>'1', 'X-Ops-Sign'=>'algorithm=sha1;version=1.1;', 'X-Ops-Timestamp'=>/.+/, 'X-Ops-Userid'=>'spec-node', 'X-Remote-Request-Id'=>/.+/}).
       to_return(:status => 200, :body => "", :headers => {})

    @chef_compliance = Reporter::ChefServerCompliance.new(opts)
  end

  it 'sends report successfully' do
    expect(@chef_compliance.send_report(@report)).to eq(true)
  end
end
