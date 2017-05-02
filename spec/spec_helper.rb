# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'webmock/rspec'

RSpec.configure do |config|
  config.file_cache_path = Chef::Config[:file_cache_path]
end
