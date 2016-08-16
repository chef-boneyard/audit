# encoding: utf-8
#
# Cookbook Name:: wrapper_audit
# Spec:: default

require 'spec_helper'

describe 'wrapper_audit::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
end
