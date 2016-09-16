# encoding: utf-8
#
# Cookbook Name:: config_winchefclient
# Spec:: default

require 'spec_helper'

describe 'config_winchefclient::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
end
