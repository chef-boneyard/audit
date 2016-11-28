# Ensure the Automate Asset Store is enabled and trigger a reconfigure otherwise
replace_or_add "Enable profiles in Automate" do
  path "/etc/delivery/delivery.rb"
  pattern "^compliance_profiles['enable'].*"
  line "compliance_profiles['enable'] = true"
  notifies :run, "execute[automate_reconfigure]", :immediately
end

execute 'automate_reconfigure' do
  command <<-EOH
    automate-ctl reconfigure
  EOH
  action :nothing
end


# Because we snapshot the instance, the initial S3 storage config goes away
# Disable the S3 store for cookbooks:
delete_lines "Avoid cookbook storage in S3" do
  path "/etc/opscode/chef-server.rb"
  pattern "^opscode_erchef.+base_resource_url"
end

replace_or_add "Enable forwarding of profiles to Automate" do
  path "/etc/opscode/chef-server.rb"
  pattern "profiles['root_url'].*"
  line "profiles['root_url'] = 'https://localhost'"
end

# Needs to run for a new instance since IPs and hostname changed
execute 'chef_reconfigure' do
  command <<-EOH
    chef-server-ctl reconfigure
    touch /etc/opscode/chef-server-reconfigured.txt
  EOH
  action :run
  not_if { File.exist?('/etc/opscode/chef-server-reconfigured.txt') }
end
