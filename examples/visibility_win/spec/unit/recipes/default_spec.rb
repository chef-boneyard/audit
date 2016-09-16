# encoding: utf-8
#
# Cookbook Name:: visibility_win
# Spec:: default

require 'spec_helper'

describe 'visibility_win::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
end
