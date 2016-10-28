# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: helpers

require 'spec_helper'
require_relative '../../../libraries/collector_classes'

describe ReportHelpers do
  let(:helpers) { Class.new { extend ReportHelpers } }

  it 'tests for runner converts all key strings to symbols' do
    tests = [{'name': 'ssh', 'url': 'https://github.com/dev-sec/tests-ssh-hardening'}]
    symbol_tests = @helpers.tests_for_runner(tests)
    expect(symbol_tests).to eq([{:name=>"ssh", :url=>"https://github.com/dev-sec/tests-ssh-hardening"}])
  end
end