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

  it 'write_to_file with interval enabled writes simple filename' do
    report = 'some info'
    profiles = [{'name'=> 'ssh', 'url'=> 'https://github.com/dev-sec/tests-ssh-hardening'}, {'name'=> 'linux', 'compliance'=> 'base/linux'}]
    interval_enabled = true
    write_to_file = false
    @helpers.write_to_file(report, profiles, interval_enabled, write_to_file)
    expected_file_path = File.expand_path("../../../../ssh_linux_.json", __FILE__)
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end

  it 'write_to_file with write to file enabled writes filename with timestamp' do
    report = 'some info'
    profiles = [{'name'=> 'ssh', 'url'=> 'https://github.com/dev-sec/tests-ssh-hardening'}, {'name'=> 'linux', 'compliance'=> 'base/linux'}]
    interval_enabled = false
    write_to_file = true
    timestamp = Time.now.utc.to_s.gsub(" ", "_")
    @helpers.write_to_file(report, profiles, interval_enabled, write_to_file)
    expected_file_path = File.expand_path("../../../../ssh_linux_-#{timestamp}.json", __FILE__)
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end

  it 'check_attributes given true for write_to_file and interval_enabled returns false' do
    write_to_file = true
    interval_enabled = true
    expect(@helpers.check_attributes(write_to_file, interval_enabled)).to eq false
  end
end