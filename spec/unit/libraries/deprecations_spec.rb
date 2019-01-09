# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: deprecations

require 'spec_helper'
require_relative '../../../libraries/deprecations'

describe 'Deprecations::Audit::ArrayProfile methods' do
  let(:audit) { Hash.new }

  before :each do
    audit['profiles'] = []
    audit['profiles'].extend(Deprecations::Audit::ArrayProfile)
  end

  describe '#[]=' do
    it 'works well when used like a hash' do
      expect { audit['profiles']['linux'] = { 'compliance': 'base/linux' } }.not_to raise_error
    end
    it 'does not affect any other object' do
      audit['others'] = []
      expect { audit['others']['linux'] = { 'compliance': 'base/linux' } }.to raise_error(TypeError)
    end
    it 'return a formatted array of hashes' do
      audit['profiles']['linux'] = { 'compliance': 'base/linux' }
      expect(audit['profiles']).to eq([{ 'name': 'linux', 'compliance': 'base/linux' }])
    end
  end

  describe '#push' do
    it 'warn with a deprecated message and return the formatted array of hashes' do
      expect(Chef::Log).to receive(:warn).with("Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes.")
      audit['profiles'].push({ 'name': 'linux', 'compliance': 'base/linux' })
      expect(audit['profiles']).to eq([{ 'name': 'linux', 'compliance': 'base/linux' }])
    end
  end
end

describe 'Deprecations::Audit::HashProfile methods' do
  let(:audit) { Hash.new }

  describe '#[]=' do
    context 'extended with audit hash' do
      before :each do
        audit['profiles'] = []
        audit.extend(Deprecations::Audit::HashProfile)
      end

      it 'does not affect any other key' do
        expect(Chef::Log).not_to receive(:warn)
        audit['quiet'] = false
        expect(audit['quiet']).to eq(false)
      end

      it 'warn if re-assign as array and return array of hashes' do
        expect(Chef::Log).to receive(:warn)
        audit['profiles'] = [{ 'name': 'linux', 'compliance': 'base/linux' }]
        expect(audit['profiles']).to eq([{ 'name': 'linux', 'compliance': 'base/linux' }])
      end
    end

    context 'not extended audit hash' do
      before :each do
        audit['profiles'] = []
      end

      it 'does not warn if re-assign' do
        expect(Chef::Log).not_to receive(:warn)
        audit['profiles'] = [{ 'name': 'linux', 'compliance': 'base/linux' }]
        expect(audit['profiles']).to eq([{ 'name': 'linux', 'compliance': 'base/linux' }])
      end

      it 'does not warn for push method' do
        expect(Chef::Log).not_to receive(:warn)
        audit['profiles'] = [{ 'name': 'apache', 'compliance': 'base/apache' }]
        audit['profiles'].push({ 'name': 'linux', 'compliance': 'base/linux' })
        expect(audit['profiles'].length).to eq(2)
      end
    end
  end
end
