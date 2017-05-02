# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'webmock/rspec'

# Berkshelf needs to connect to internet
WebMock.disable_net_connect!(
  allow: [/supermarket.chef.io/, /127.0.0.1:8889/, /s3.amazonaws.com\/community-files.opscode.com/]
)

RSpec.configure do |config|
  config.file_cache_path = Chef::Config[:file_cache_path]
end
