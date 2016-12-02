# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: json-file

require 'spec_helper'
require_relative '../../../libraries/collector_classes'

describe 'Collector::JsonFile methods' do
  it 'writes the report to a file on disk' do
    report = 'some info'
    timestamp = Time.now.utc.to_s.tr(' ', '_').tr(':', '-')
    @jsonfile = Collector::JsonFile.new(report, timestamp).send_report
    expected_file_path = File.expand_path("../../../../inspec-#{timestamp}.json", __FILE__)
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end
end