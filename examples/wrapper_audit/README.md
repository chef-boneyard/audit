# Example: Wrapper cookbook for `Audit`

This example cookbook demonstrates how you could wrap the audit cookbook with a customizable internal cookbook. This might be done to easily change default attributes set in the audit cookbook.  The wrapper also helps you control the versioning of the audit cookbook in your environment.  It can also be useful to help create roles to target where the audit cookbook applies, or even set attributes on nodes to apply Compliance profiles (if you had some you want to run on all machines).

## Requirements

### Platforms
- Windows Server 2008 R2
- Windows Server 2012
- Windows Server 2012 R2
- Ubuntu 12.04
- Ubuntu 14.04

### Chef

- Chef 12+

### Cookbooks

- `audit`
- `automate_win`

## Attributes

There are no custom attributes for this cookbook.

## Usage

Include `wrapper_audit::default` in a node's `run_list`.  This will also pull down the community audit cookbook, which is used to run Chef Compliance profiles.  These profiles will create a report and send it to Chef Compliance or Chef Automate, depending on your `['audit']['reporter']` setting.

This cookbook also consumes the example cookbook `automate_win`, which demonstrates how to setup chef-client to ingest Chef Automate data.
