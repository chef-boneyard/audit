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

  it 'returns the correct control status' do
    expect(@helpers.control_status(nil)).to eq(nil)
    expect(@helpers.control_status([{"status"=>"failed"}])).to eq('failed')
    expect(@helpers.control_status([{"status"=>"passed"}])).to eq('passed')
    expect(@helpers.control_status([{"status"=>"passed"},{"status"=>"failed"}])).to eq('failed')
    expect(@helpers.control_status([{"status"=>"failed"},{"status"=>"passed"}])).to eq('failed')
    expect(@helpers.control_status([{"status"=>"passed"},{"status"=>"skipped"}])).to eq('skipped')
    expect(@helpers.control_status([{"status"=>"skipped"},{"status"=>"failed"}])).to eq('failed')
  end

  it 'reports impact criticality correctly' do
    expect(@helpers.impact_to_s(0)).to eq('minor')
    expect(@helpers.impact_to_s(0.1234)).to eq('minor')
    expect(@helpers.impact_to_s(0.4)).to eq('major')
    expect(@helpers.impact_to_s(0.69)).to eq('major')
    expect(@helpers.impact_to_s(0.7)).to eq('critical')
    expect(@helpers.impact_to_s(1.0)).to eq('critical')
  end

  it 'reports compliance status like a compliance officer' do
    passed = {"total"=>5, "passed"=>{"total"=>3}, "skipped"=>{"total"=>2}, "failed"=>{"total"=>0, "minor"=>0, "major"=>0, "critical"=>0}}
    failed = {"total"=>5, "passed"=>{"total"=>1}, "skipped"=>{"total"=>1}, "failed"=>{"total"=>3, "minor"=>1, "major"=>1, "critical"=>1}}
    skipped = {"total"=>5, "passed"=>{"total"=>0}, "skipped"=>{"total"=>5}, "failed"=>{"total"=>0, "minor"=>0, "major"=>0, "critical"=>0}}
    expect(@helpers.compliance_status(nil)).to eq('unknown')
    expect(@helpers.compliance_status(failed)).to eq('failed')
    expect(@helpers.compliance_status(passed)).to eq('passed')
    expect(@helpers.compliance_status(skipped)).to eq('skipped')
  end

  it 'counts controls like an accountant' do
    profi = [{"name"=>"test-profile",
              "controls"=>
              [{"id"=>"Checking /etc/missing1.rb existance",
                "impact"=>0,
                "results"=>[{"status"=>"failed"}]},
              {"id"=>"Checking /etc/missing2.rb existance",
                "impact"=>0.5,
                "results"=>[{"status"=>"failed"}]},
              {"id"=>"Checking /etc/missing3.rb existance",
                "impact"=>0.8,
                "results"=>[{"status"=>"failed"}]},
              {"id"=>"Checking /etc/passwd existance",
                "impact"=>0.88,
                "results"=>[{"status"=>"passed"}]},
              {"id"=>"Checking /etc/something existance",
                "impact"=>1.0,
                "results"=>[{"status"=>"skipped"}]}]
    }]
    expected_count = {"total"=>5, "passed"=>{"total"=>1}, "skipped"=>{"total"=>1}, "failed"=>{"total"=>3, "minor"=>1, "major"=>1, "critical"=>1}}
    expect(@helpers.count_controls(profi)).to eq(expected_count)
  end
end
