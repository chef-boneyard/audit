# Example: Vagrant with Chef Server and Chef Compliance

This directory contains a simple vagrant setup that expects you have a Chef Server already running.

1.) Upload cookbook to Chef Server

```
mkdir cookbooks
cd cookbooks
git clone https://github.com/chef-cookbooks/audit.git
cd ..
chef exec knife cookbook upload audit -o ./cookbooks -c test-chef-server/knife.rb
```

2.) Adapt the chef Server settings in vagrant file:

```
chef.chef_server_url = 'https://192.168.33.101/organizations/brewinc'
chef.validation_key_path = 'brewinc-validator.pem'
chef.validation_client_name = 'brewinc-validator'
```

3.) Start node with chef-client

```
vagrant up
# or if you have it already up
vagrant provision
```
