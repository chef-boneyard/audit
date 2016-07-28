class MockData
    def self.chef_client_report
      { :node=>"chef-client.solo",
        :os=>{
          :release=>"10.11.5",
          :family=>"mac_os_x"
        },
        :environment=>"dev_blog",
        :reports=>
        {"mylinux-success-failure"=>
          {"version"=>"0.27.1",
           "summary"=>{"duration"=>0.006629, "example_count"=>9, "failure_count"=>6, "skip_count"=>2},
           "profiles"=>
            {"mylinux-failure-success"=>
              {"name"=>"mylinux-failure-success",
               "title"=>"Mylinux Failure Success",
               "maintainer"=>"Chef Software, Inc.",
               "copyright"=>"Chef Software, Inc.",
               "copyright_email"=>"support@chef.io",
               "license"=>"Apache 2 license",
               "summary"=>"Demonstrates the use of InSpec Compliance Profile",
               "version"=>"2.7.0",
               "supports"=>[{"os-family"=>"unix"}],
               "controls"=>
                {"Checking /etc/missing2.rb existance"=>
                  {"title"=>"Check /etc/missing2.rb",
                   "desc"=>"File test in failure-success.rb",
                   "impact"=>0,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/missing2.rb existance' do\n  impact 0\n  title \"Check /etc/missing2.rb\"\n  desc \"File test in failure-success.rb\"\n  describe file('/etc/missing2.rb') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb",
                     "line"=>2},
                   "results"=>
                    [{"status"=>"failed",
                      "code_desc"=>"File /etc/missing2.rb should be file",
                      "run_time"=>0.004004,
                      "start_time"=>"2016-07-19 07:50:54 +0100",
                      "message"=>"expected `File /etc/missing2.rb.file?` to return true, got false"}]},
                 "Checking /etc/missing4.rb existance"=>
                  {"title"=>"Check /etc/missing4.rb",
                   "desc"=>"File test in failure-success.rb",
                   "impact"=>0.22,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/missing4.rb existance' do\n  impact 0.22\n  title \"Check /etc/missing4.rb\"\n  desc \"File test in failure-success.rb\"\n  describe file('/etc/missing4.rb') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb",
                     "line"=>11},
                   "results"=>
                    [{"status"=>"failed",
                      "code_desc"=>"File /etc/missing4.rb should be file",
                      "run_time"=>0.000206,
                      "start_time"=>"2016-07-19 07:50:54 +0100",
                      "message"=>"expected `File /etc/missing4.rb.file?` to return true, got false"}]},
                 "Checking /etc/missing5.rb existance"=>
                  {"title"=>"Check /etc/missing5.rb",
                   "desc"=>"File test in failure-success.rb",
                   "impact"=>0.5,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/missing5.rb existance' do\n  impact 0.5\n  title \"Check /etc/missing5.rb\"\n  desc \"File test in failure-success.rb\"\n  describe file('/etc/missing5.rb') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb",
                     "line"=>20},
                   "results"=>
                    [{"status"=>"failed",
                      "code_desc"=>"File /etc/missing5.rb should be file",
                      "run_time"=>0.000125,
                      "start_time"=>"2016-07-19 07:50:54 +0100",
                      "message"=>"expected `File /etc/missing5.rb.file?` to return true, got false"}]},
                 "Checking /etc/missing6.rb existance"=>
                  {"title"=>"Check /etc/missing6.rb",
                   "desc"=>"File test in failure-success.rb",
                   "impact"=>0.6,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/missing6.rb existance' do\n  impact 0.6\n  title \"Check /etc/missing6.rb\"\n  desc \"File test in failure-success.rb\"\n  describe file('/etc/missing6.rb') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb",
                     "line"=>29},
                   "results"=>
                    [{"status"=>"failed",
                      "code_desc"=>"File /etc/missing6.rb should be file",
                      "run_time"=>0.000157,
                      "start_time"=>"2016-07-19 07:50:54 +0100",
                      "message"=>"expected `File /etc/missing6.rb.file?` to return true, got false"}]},
                 "Checking /etc/missing7.rb existance"=>
                  {"title"=>"Check /etc/missing7.rb",
                   "desc"=>"File test in failure-success.rb",
                   "impact"=>0.05,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/missing7.rb existance' do\n  impact 0.05\n  title \"Check /etc/missing7.rb\"\n  desc \"File test in failure-success.rb\"\n  describe file('/etc/missing7.rb') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb",
                     "line"=>38},
                   "results"=>
                    [{"status"=>"failed",
                      "code_desc"=>"File /etc/missing7.rb should be file",
                      "run_time"=>0.000239,
                      "start_time"=>"2016-07-19 07:50:54 +0100",
                      "message"=>"expected `File /etc/missing7.rb.file?` to return true, got false"}]},
                 "Checking /etc/group existance"=>
                  {"title"=>"Check /etc/group",
                   "desc"=>"File test in failure-success.rb",
                   "impact"=>1,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/group existance' do\n  impact 1\n  title \"Check /etc/group\"\n  desc \"File test in failure-success.rb\"\n  describe file('/etc/group') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure-success.rb",
                     "line"=>47},
                   "results"=>[{"status"=>"passed", "code_desc"=>"File /etc/group should be file", "run_time"=>0.000224, "start_time"=>"2016-07-19 07:50:54 +0100"}]},
                 "Checking /etc/missing3.rb"=>
                  {"title"=>"Check /etc/missing3.rb",
                   "desc"=>"File test in failure.rb",
                   "impact"=>0.7,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'Checking /etc/missing3.rb' do\n  impact 0.7\n  title \"Check /etc/missing3.rb\"\n  desc \"File test in failure.rb\"\n  describe file('/etc/missing3.rb') do\n    it { should be_file }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/failure.rb",
                     "line"=>2},
                   "results"=>
                    [{"status"=>"failed",
                      "code_desc"=>"File /etc/missing3.rb should be file",
                      "run_time"=>0.00021,
                      "start_time"=>"2016-07-19 07:50:54 +0100",
                      "message"=>"expected `File /etc/missing3.rb.file?` to return true, got false"}]},
                 "control-1 guarded by only_if"=>
                  {"title"=>"Control used to test skipped group",
                   "desc"=>nil,
                   "impact"=>0.45,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'control-1 guarded by only_if' do\n  impact 0.45\n  title 'Control used to test skipped group'\n  describe command('missing-command') do\n    its('stdout') { should_not match(/^bingo/) }\n  end\n  describe command('missing-command-2') do\n    its('stdout') { should_not match(/^bingo/) }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/skipped.rb",
                     "line"=>6},
                   "results"=>
                    [{"status"=>"skipped",
                      "code_desc"=>"Operating System Detection Skipped control due to only_if condition.",
                      "skip_message"=>"Skipped control due to only_if condition.",
                      "resource"=>"Operating System Detection",
                      "run_time"=>1.5e-05,
                      "start_time"=>"2016-07-19 07:50:54 +0100"}]},
                 "control-2 guarded by only_if"=>
                  {"title"=>"Control used to test skipped group",
                   "desc"=>nil,
                   "impact"=>0.15,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'control-2 guarded by only_if' do\n  impact 0.15\n  title 'Control used to test skipped group'\n  describe command('missing-command-3') do\n    its('stdout') { should_not match(/^bingo/) }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/mylinux-failure-success/controls/skipped.rb",
                     "line"=>17},
                   "results"=>
                    [{"status"=>"skipped",
                      "code_desc"=>"Operating System Detection Skipped control due to only_if condition.",
                      "skip_message"=>"Skipped control due to only_if condition.",
                      "resource"=>"Operating System Detection",
                      "run_time"=>7.0e-06,
                      "start_time"=>"2016-07-19 07:50:54 +0100"}]}},
               "groups"=>
                {"controls/failure-success.rb"=>
                  {"title"=>nil,
                   "controls"=>
                    ["Checking /etc/missing2.rb existance",
                     "Checking /etc/missing4.rb existance",
                     "Checking /etc/missing5.rb existance",
                     "Checking /etc/missing6.rb existance",
                     "Checking /etc/missing7.rb existance",
                     "Checking /etc/group existance"]},
                 "controls/failure.rb"=>{"title"=>nil, "controls"=>["Checking /etc/missing3.rb"]},
                 "controls/skipped.rb"=>{"title"=>"Title for skipped.rb", "controls"=>["control-1 guarded by only_if", "control-2 guarded by only_if"]}},
               "attributes"=>[]}},
           "other_checks"=>[]},
         "tmp_compliance_profile"=>
          {"version"=>"0.27.1",
           "summary"=>{"duration"=>0.022248, "example_count"=>2, "failure_count"=>0, "skip_count"=>0},
           "profiles"=>
            {"tmp_compliance_profile"=>
              {"name"=>"tmp_compliance_profile",
               "title"=>"/tmp Compliance Profile",
               "summary"=>"An Example Compliance Profile",
               "version"=>"0.1.1",
               "maintainer"=>"Someone <someone@example.com>",
               "license"=>"Apache 2.0 License",
               "copyright"=>"Someone <someone@example.com>",
               "supports"=>[],
               "controls"=>
                {"tmp-1.0"=>
                  {"title"=>"A /tmp directory must exist",
                   "desc"=>"A /tmp directory must exist",
                   "impact"=>0.3,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'tmp-1.0' do\n  impact 0.3\n  title 'A /tmp directory must exist'\n  desc 'A /tmp directory must exist'\n  describe file '/tmp' do\n    it { should be_directory }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb",
                     "line"=>3},
                   "results"=>[{"status"=>"passed", "code_desc"=>"File /tmp should be directory", "run_time"=>0.000286, "start_time"=>"2016-07-19 07:50:54 +0100"}]},
                 "tmp-1.1"=>
                  {"title"=>"/tmp directory is owned by the root user",
                   "desc"=>"The /tmp directory must be owned by the root user",
                   "impact"=>0.3,
                   "refs"=>[],
                   "tags"=>{},
                   "code"=>
                    "control 'tmp-1.1' do\n  impact 0.3\n  title '/tmp directory is owned by the root user'\n  desc 'The /tmp directory must be owned by the root user'\n  describe file '/tmp' do\n    it { should be_owned_by 'root' }\n  end\nend\n",
                   "source_location"=>
                    {"ref"=>
                      "/tmp/chef-client/cache/cookbooks/mytest-cookbook/recipes/../files/default/compliance_profiles/tmp_compliance_profile/controls/tmp.rb",
                     "line"=>12},
                   "results"=>[{"status"=>"passed", "code_desc"=>"File /tmp should be owned by \"root\"", "run_time"=>0.021412, "start_time"=>"2016-07-19 07:50:54 +0100"}]}},
               "groups"=>{"controls/tmp.rb"=>{"title"=>"/tmp Compliance Profile", "controls"=>["tmp-1.0", "tmp-1.1"]}},
               "attributes"=>[]}},
           "other_checks"=>[]}},
        :profiles=>{"mylinux-success-failure"=>"alex", "tmp_compliance_profile"=>"nathen"}}
    end
end
