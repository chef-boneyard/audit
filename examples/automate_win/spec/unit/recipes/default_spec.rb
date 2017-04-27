# encoding: utf-8
#
# Cookbook Name:: automate_win
# Spec:: default

require 'spec_helper'

describe 'automate_win::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
end
