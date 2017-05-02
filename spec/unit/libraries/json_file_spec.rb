# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: json-file

require 'spec_helper'
require_relative '../../../libraries/reporters/json_file'

describe 'Reporter::JsonFile methods' do
  it 'writes the report to a file on disk' do
    report = 'some info'
    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
    expected_file_path = File.expand_path("inspec-#{timestamp}.json", File.dirname(__FILE__))
    @jsonfile = Reporter::JsonFile.new({file: expected_file_path}).send_report(report)
    expect(File).to exist("#{expected_file_path}")
    File.delete("#{expected_file_path}")
  end
end
