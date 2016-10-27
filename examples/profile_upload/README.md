# profile_upload

Example cookbook used to upload a profile to chef-compliance.

To use this cookbook:

1) ensure you update the .kitchen.yml with your:
   * chef-compliance server url
   * refresh_token
   * user (owner)

2) create a directory in this directory named 'profile_tar', and stick an archived
   profile in there (something like: ssh-hardening.tar.gz)
     (Note: you can easily archive an existing profile using `inspec archive PATH`)

3) run `kitchen converge`

4) go look in chef-compliance, under the compliance profiles section, and see your
   uploaded profile! tada!