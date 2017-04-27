# Example: Automate Ingest Cookbook

This example cookbook demonstrates how to setup chef-client to send converge data to your Chef Automate.  In your environment, the content of this cookbook might likely just be added to an existing cookbook that configures chef-client in Windows, or even a cookbook that configures common Windows components on your machines.  This cookbook is based on the information in `https://docs.chef.io/ingest_data_chef_automate.html`

This example cookbook is also consumed in the example wrapper cookbook, named `wrapper_audit`

## Requirements

### Platforms

- Windows Server 2012 R2

### Chef

- Chef 12+

### Cookbooks

- `windows`

## Attributes

No custom.

## Usage

For this example, you would add the following recipes to a node's run list:
- `automate_win::chef_client_config` - Add configuration to chef-client for Chef Automate data ingest.
