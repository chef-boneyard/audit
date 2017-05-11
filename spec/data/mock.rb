class MockData
  def self.node_info
    { node: "chef-client.solo",
      environment: 'My Prod Env' }
  end

  def self.inspec_results
    {"version":"1.2.1",
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
         [{"title":"A /tmp directory must exist",
           "desc":"A /tmp directory must exist",
           "impact":0.3,
           "refs":[],
           "tags":{},
           "code":"control 'tmp-1.0' do\n  impact 0.3\n  title 'A /tmp directory must exist'\n  desc 'A /tmp directory must exist'\n  describe file '/tmp' do\n    it { should be_directory }\n  end\nend\n",
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
      "other_checks":[],
      "statistics":{"duration":0.032332}}
  end
end
