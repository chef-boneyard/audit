# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: helpers

require 'spec_helper'
require_relative '../../../libraries/helper'

describe ReportHelpers do
  let(:helpers) { Class.new { extend ReportHelpers } }

  it 'tests_for_runner converts all key strings to symbols' do
    tests = [{'name': 'ssh', 'url': 'https://github.com/dev-sec/tests-ssh-hardening'}]
    symbol_tests = @helpers.tests_for_runner(tests)
    expect(symbol_tests).to eq([{:name=>"ssh", :url=>"https://github.com/dev-sec/tests-ssh-hardening"}])
  end

  it 'report_timing_file returns where the report timing file is located' do
    expect(@helpers.report_timing_file).to eq("#{Chef::Config[:file_cache_path]}/compliance/report_timing.json")
  end

  it 'handle_reporters returns array of reporters when given array' do
    reporters = ['chef-compliance', 'json-file']
    expect(@helpers.handle_reporters(reporters)).to eq(['chef-compliance', 'json-file'])
  end

  it 'handle_reporters returns array of reporters when given string' do
    reporters = 'chef-compliance'
    expect(@helpers.handle_reporters(reporters)).to eq(['chef-compliance'])
  end

  it 'create_timestamp_file creates a new file' do
    expected_file_path = @helpers.report_timing_file
    @helpers.create_timestamp_file
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end
end
