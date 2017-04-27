# encoding: utf-8
name 'wrapper_audit'
maintainer 'Chef Software, Inc'
maintainer_email 'support@chef.io'
license 'Apache-2'
description 'Wrapper cookbook that runs Audit cookbook.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

# Put whatever operating systems your company supports where you may want
# to use Compliance profiles
supports 'windows'

depends 'audit', '>= 0.14.1'
depends 'automate_win', '>=0.2.0'
