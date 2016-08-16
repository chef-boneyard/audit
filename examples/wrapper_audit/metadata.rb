# encoding: utf-8
name 'wrapper_audit'
maintainer 'Your Organization'
maintainer_email 'yourorganizationemail@domain.com'
license 'Proprietary - All Rights Reserved'
description 'Wrapper cookbook that runs Audit cookbook.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

source_url 'https://github.com/chef-cookbooks/audit'
issues_url 'https://github.com/chef-cookbooks/audit/issues'

# Put whatever operating systems your company supports where you may want
# to use Compliance profiles
supports 'windows'
supports 'ubuntu', '>= 14.0.4'

depends 'audit', '>= 0.14.1'
depends 'config_winchefclient', '>=0.1.8'
