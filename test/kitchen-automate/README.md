# kitchen-automate Cookbook

Integration testing for the `audit` cookbook.

## Purpose of this cookbook

Tests the audit cookbook for the `chef-visibility` and `chef-server-visibility` collectors with a node managed by a Chef Server that is integrated with Chef Automate.

**Note:** This cookbook has been designed only for testing purposes, trying to minimize the external dependencies and test time. Don't use it for production.

## Requirements

 * `test-kitchen` installed with `kitchen-ec2` driver.
 * ENV variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in order to create and destroy the test ec2 instance.
 * Access to the private SSH key (`~/.ssh/kitchen-key-compliance.pem`) used in `.kitchen.yml`

## How is it working?

This cookbook uses the `kitchen-ec2` driver in order to spin up an OpsWorks (Chef Server + Automate) instance in ec2 using a previously snapshotted OpsWorks instance.

A `kitchen test` will:
1. Create the ec2 instance
2. Converge the node with chef_zero using the `default` recipe
3. Test the success of the reporting using InSpec resources in `test/integration/default/`. This is verifying that compliance scan reports exist in ElasticSearch (used by Chef Automate) for both converges.
4. Terminate the instance

Let's look a bit closer and the recipes used during the converge step:

1. `harakiri` - If the converge fails and the instance is not terminated, the `harakiri` recipe configures the instance to self terminate after 4 hours of operation.
2. `configure_services` - Idempotently configures the Chef Server and Chef Automate in order to enable the compliance profiles asset store and proxying.
3. `upload_profile` - Downloads a remote profile and uploads it to the Automate Asset Store via the API and the data collector token
4. `bootstrap_localhost` - In order to test the `audit` cookbook with the `chef-server-visibility` collector, we need a node that is managed by a Chef Server. This recipe:
  a) Configures `knife.rb` to talk to the local Chef Server
  b) Uploads to the Chef Server all the cookbook synced by `test-kitchen` to `/tmp/kitchen/cookbooks`
  c) Sets up SSH so we can bootstrap localhost via SSH. We are using `/tmp/kitchen/client.pem` as a private key as kitchen creates it for us already.
  d) Bootstraps localhost as a node for the local Chef Server with an empty runlist
5. `converge_localhost` - Creates attribute files and converges the `audit::default` recipe once for each of the two collectors: `chef-server-visibility` and `chef-visibility`. The `chef-server-visibility` converge uses the compliance profile stored in Automate (uploaded by the `upload_profile` recipe).


## Creating a starting ami for your account

You can create an ec2 ami for this cookbook by launching an official OpsWorks instance. Once the instance is operational, you can optionally make this change:

```bash
# enable profiles in Automate
echo "compliance_profiles['enable'] = true" >> /etc/delivery/delivery.rb
automate-ctl reconfigure
```

It's optional because this cookbook has a recipe (`configure_services`) to make this change, but takes an extra minute per converge later on.
Stop the instance and create an image from it from the AWS Management Console with option `Image > Create Image`. Once the image id is available, use it for the `image_id` option in `.kitchen.yml`.
