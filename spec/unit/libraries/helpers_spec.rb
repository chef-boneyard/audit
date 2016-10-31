# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: helpers

require 'spec_helper'
require_relative '../../../libraries/collector_classes'

describe ReportHelpers do
  let(:helpers) { Class.new { extend ReportHelpers } }

  it 'tests_for_runner converts all key strings to symbols' do
    tests = [{'name': 'ssh', 'url': 'https://github.com/dev-sec/tests-ssh-hardening'}]
    symbol_tests = @helpers.tests_for_runner(tests)
    expect(symbol_tests).to eq([{:name=>"ssh", :url=>"https://github.com/dev-sec/tests-ssh-hardening"}])
  end

  it 'extract_profile_names given profiles returns names' do
    profiles = [{'name'=> 'ssh', 'url'=> 'https://github.com/dev-sec/tests-ssh-hardening'}, {'name'=> 'linux', 'compliance'=> 'base/linux'}]
    names = @helpers.extract_profile_names(profiles)
    expect(names).to eq 'ssh_linux_'
  end

  it 'extract_profile_names given profiles without a name returns names' do
    profiles = [{'url'=> 'https://github.com/dev-sec/tests-ssh-hardening'}, {'name'=> 'linux', 'compliance'=> 'base/linux'}]
    names = @helpers.extract_profile_names(profiles)
    expect(names).to eq 'unknown_linux_'
  end

  it 'create_timestamp_file creates a new file' do
    expected_file_path = File.expand_path("../../../../report_timing.json", __FILE__)
    @report.create_timestamp_file
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end
end