# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: json-file

require 'spec_helper'
require_relative '../../../libraries/collector_classes'

describe 'Collector::JsonFile methods' do
  it 'writes the report to a file on disk' do
    profiles = [{'name'=> 'ssh', 'url'=> 'https://github.com/dev-sec/tests-ssh-hardening'}, {'name'=> 'linux', 'compliance'=> 'base/linux'}]
    report = 'some info'
    timestamp = Time.now.utc.to_s.tr(' ', '_')
    @jsonfile = Collector::JsonFile.new(report, profiles, timestamp).send_report
    expected_file_path = File.expand_path("../../../../ssh_linux_-#{timestamp}.json", __FILE__)
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end
end