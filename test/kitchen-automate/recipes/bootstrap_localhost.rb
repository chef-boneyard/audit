directory "/root/.chef" do
  mode 00770
  action :create
end

# Configure knife against the local Chef Server
template '/root/.chef/knife.rb' do
  source 'knife.rb.erb'
  mode '0660'
  variables(
    log_level: 'info'
  )
end

# Upload the cookbooks from the location specified in /root/.chef/knife.rb
# This is the directory where test-kitchen syncs the cookbooks into
execute "Uploading cookbooks to Chef Server" do
  command <<-EOH
    sudo knife cookbook upload -a
    sudo knife cookbook list
  EOH
  live_stream true
  action :run
end

# Ensure the node is in the expected state
raise "Cannot find /tmp/kitchen/client.pem" unless File.exist?('/tmp/kitchen/client.pem')
raise "Cannot find /home/ec2-user/.ssh/authorized_keys" unless File.exist?('/home/ec2-user/.ssh/authorized_keys')

# Add a public key to be used for SSH bootstrapping
execute "Add SSH public key to be used by self bootstrapping" do
  command <<-EOH
    key=$(ssh-keygen -y -f /tmp/kitchen/client.pem)
    echo "$key kitchen_client.pem" >> /home/ec2-user/.ssh/authorized_keys
  EOH
  action :run
  not_if { File.open('/home/ec2-user/.ssh/authorized_keys').read().index('kitchen_client.pem') }
end

# Bootstraps the node against the local Chef Server. Will run on first converge only as  '/etc/chef/client.pem' is not in place yet
execute "Bootstrapping the node with local Chef Server" do
  command <<-EOH
    sudo knife bootstrap localhost --sudo \
      --ssh-user "ec2-user" \
      --ssh-identity-file /tmp/kitchen/client.pem \
      --node-name "testus" \
      --json-attribute-file /tmp/kitchen/dna.json \
      --node-ssl-verify-mode none
  EOH
  live_stream true
  action :run
  not_if { File.exist?('/etc/chef/client.pem') }
end
