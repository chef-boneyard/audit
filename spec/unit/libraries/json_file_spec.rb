# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: json-file

require 'spec_helper'
require_relative '../../../libraries/reporters/json_file'

describe 'Reporter::JsonFile methods' do
  it 'writes the report to a file on disk' do
    report = { 'data' => 'some info' }
    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
    expected_file_path = File.expand_path("inspec-#{timestamp}.json", File.dirname(__FILE__))
    @jsonfile = Reporter::JsonFile.new({file: expected_file_path}).send_report(report)
    expect(File).to exist("#{expected_file_path}")
    # we sent a ruby hash and expect valid json in the file
    content = JSON.parse(File.read expected_file_path)
    expect(content).to eq(report)
    File.delete("#{expected_file_path}")
  end
end
