# Example: Vagrant with Chef Server and Chef Compliance

This directory contains a simple vagrant setup that expects you have a Chef Server already running.

1.) Upload cookbook to Chef Server

```
$ berks vendor -e integration
Resolving cookbook dependencies...
Fetching 'audit' from source at .
Using audit (2.0.0) from source at .
Using compat_resource (12.16.1)
Using chef_handler (2.0.0)
Vendoring audit (2.0.0) to /Users/jmiller/Devel/ChefProject/audit/berks-cookbooks/audit
Vendoring chef_handler (2.0.0) to /Users/jmiller/Devel/ChefProject/audit/berks-cookbooks/chef_handler
Vendoring compat_resource (12.16.1) to /Users/jmiller/Devel/ChefProject/audit/berks-cookbooks/compat_resource
$ knife cookbook upload -a -o berks-cookbooks
Uploading audit          [2.0.0]
Uploading chef_handler   [2.0.0]
Uploading compat_resource [12.16.1]
Uploaded all cookbooks.
$
```

Or if you want to upload cookbooks individually, you could use `knife`. This expects that `compat_resource` and `chef_handler` are already uploaded to Chef Server.

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
