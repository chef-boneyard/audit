
# Create the attributes file to test the 'chef-server-visibility' collector
file '/root/attrs_chef-server-visibility.json' do
  content <<-EOH
  {
    "audit": {
      "collector": "chef-server-visibility",
      "insecure": true,
      "profiles": [
        {
          "name": "ssh-hardening",
          "compliance": "admin/ssh-hardening"
        }
      ]
    }
  }
  EOH
  mode 00600
end

# Not needed for 'chef-server-visibility' collector converge
delete_lines "Delete data_collector.server_url from /etc/chef/client.rb" do
  path "/etc/chef/client.rb"
  pattern "^data_collector.server_url.*"
end
delete_lines "Delete data_collector.token from /etc/chef/client.rb" do
  path "/etc/chef/client.rb"
  pattern "^data_collector.token.*"
end

# Executes chef-client if the node is bootstrapped('/etc/chef/client.pem' file to exists)
# Removing the 'audit' attributes tree to avoid attributes state issues between multiple converges
execute "### Run chef-client w/ collector chef-server-visibility" do
  command <<-EOH
    echo "*** Removing audit node attributes from the Chef Server..."
    sudo knife exec -E "nodes.transform(:all) {|n| n.normal_attrs.delete(:audit) rescue nil }"
    echo "*** Removing local insights-* ElasticSearch indices"
    curl -X DELETE "http://127.0.0.1:9200/insights-*"
    echo "*** Showing testus node with normal attributes"
    sudo knife node show testus -m
    sudo chef-client --override-runlist "recipe[audit::default]" \
      --json-attributes /root/attrs_chef-server-visibility.json
  EOH
  live_stream true
  action :run
  only_if { File.exist?('/etc/chef/client.pem') }
end


# Create the attributes file to test the 'chef-visibility' collector
file '/root/attrs_chef-visibility.json' do
  content <<-EOH
  {
    "audit": {
      "collector": "chef-visibility",
      "insecure": true,
      "profiles": [
        {
          "name": "linux-patch-benchmark",
          "url": "https://github.com/dev-sec/linux-patch-benchmark/archive/master.zip"
        }
      ]
    }
  }
  EOH
  mode 00600
end

# Collector 'chef-visibility' needs these client.rb settings:
replace_or_add "Add data_collector.server_url to /etc/chef/client.rb" do
  path "/etc/chef/client.rb"
  pattern "^data_collector.server_url.*"
  line "data_collector.server_url 'https://127.0.0.1/data-collector/v0/'"
end
replace_or_add "Add data_collector.token to /etc/chef/client.rb" do
  path "/etc/chef/client.rb"
  pattern "^data_collector.token.*"
  line "data_collector.token '#{dc_token}'"
end

# Executes chef-client if the node is bootstrapped('/etc/chef/client.pem' file to exists)
# Removing the 'audit' attributes tree to avoid attributes state issues between multiple converges
execute "### Run chef-client w/ collector chef-visibility" do
  command <<-EOH
    echo "*** Removing audit node attributes from the Chef Server..."
    sudo knife exec -E "nodes.transform(:all) {|n| n.normal_attrs.delete(:audit) rescue nil }"
    echo "*** Showing testus node with normal attributes"
    sudo knife node show testus -m
    sudo chef-client --override-runlist "recipe[audit::default]" \
      --json-attributes /root/attrs_chef-visibility.json
    # give time to ElasticSearch to index the report
    sleep 10
  EOH
  live_stream true
  action :run
  only_if { File.exist?('/etc/chef/client.pem') }
end
