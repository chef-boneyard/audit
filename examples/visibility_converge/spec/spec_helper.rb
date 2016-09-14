# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
ChefSpec::Coverage.start!
# Configure defaults
RSpec.configure do |config|
  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'windows'
  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '2012R2'
end
