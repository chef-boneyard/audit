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
    node_info = {node:"default-ubuntu-1404", os:{release:"14.04", family:"ubuntu"}, environment:"_default"}
    raise_if_unreachable = true

    @report_min = {
      "version":"1.21.0",
      "controls":[{"id":"tmp-1.0","profile_id":"tmp_compliance_profile","status":"passed","code_desc":"File /tmp should be directory"},{"id":"tmp-1.1","profile_id":"tmp_compliance_profile","status":"passed","code_desc":"File /tmp should be owned by \"root\""}],
      "statistics":{"duration":0.028643}
    }

    @report_full = {
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
      "name":"tmp_compliance_profile",
      "compliance":"admin/tmp_compliance_profile"
    }]

    @enriched_report_expected = {
      "node":"default-ubuntu-1404",
      "os":{"release":"14.04", "family":"ubuntu"},
      "environment":"_default",
      "reports":{"tmp_compliance_profile":{
        "version":"1.21.0",
        "controls":[{"id":"tmp-1.0","profile_id":"tmp_compliance_profile","status":"passed","code_desc":"File /tmp should be directory"},{"id":"tmp-1.1","profile_id":"tmp_compliance_profile","status":"passed","code_desc":"File /tmp should be owned by \"root\""}],
        "statistics":{"duration":0.028643}
        }},
      "profiles":{"tmp_compliance_profile":"admin"}
    }

    opts = {
      url: url,
      node_info: node_info,
      raise_if_unreachable: raise_if_unreachable,
      token: 1234,
      source_location: @source_location,
    }

    @chef_compliance = Reporter::ChefCompliance.new(opts)

    stub_request(:post, url).
       with(:body => @enriched_report_expected.to_json,
            :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer 1234', 'User-Agent'=>/.+/}).
       to_return(:status => 200, :body => "", :headers => {})
  end

  it 'sends report successfully' do
    expect(@chef_compliance.send_report(@report_full)).to eq(true)
  end

  it 'transforms full json to min-json' do
    expect(@chef_compliance.transform(@report_full)).to eq(@report_min)
  end

  it 'enriches the report correctly' do
    expect(@chef_compliance.enriched_report(@report_min, @source_location)).to eq(@enriched_report_expected)
  end
end
