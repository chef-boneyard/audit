# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'webmock/rspec'

# Berkshelf needs to connect to internet
WebMock.allow_net_connect!

RSpec.configure do |config|
  config.file_cache_path = Chef::Config[:file_cache_path]
end
