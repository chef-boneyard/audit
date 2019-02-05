# encoding: utf-8
#
# Cookbook Name:: audit
# Spec:: fetcher
#
# Copyright 2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require_relative '../../../files/default/vendor/chef-server/fetcher'

describe ChefServer::Fetcher do
  let(:mynode) { Chef::Node.new }
  let(:myprofile) { 'compliance://foobazz' }
  let(:profile_hash) do
    {
      name: 'linux-baseline',
      compliance: 'user/linux-baseline',
      version: '2.1.0',
    }
  end
  let(:profile_hash_target) do
    '/organizations/org/owners/user/compliance/linux-baseline/version/2.1.0/tar'
  end
  let(:non_profile_url) do
    'http://127.0.0.1:8889/organizations/org/owners/user/compliance/linux-baseline/version/2.1.0/tar'
  end

  context 'when target is a string' do
    before :each do
      allow(Chef).to receive(:node).and_return(mynode)
      allow(ChefServer::Fetcher).to receive(:construct_url).and_return(URI(myprofile))
      allow(ChefServer::Fetcher).to receive(:chef_server_visibility?).and_return(true)
    end

    it 'should resolve a target' do
      mynode.default['audit']['fetcher'] = nil
      res = ChefServer::Fetcher.resolve(myprofile)
      expect(res.target).to eq(URI(myprofile))
    end

    it 'should add /compliance URL prefix if needed' do
      mynode.default['audit']['fetcher'] = 'chef-server'
      expect(ChefServer::Fetcher.url_prefix).to eq('/compliance')
    end

    it 'should omit /compliance if not' do
      mynode.default['audit']['fetcher'] = nil
      expect(ChefServer::Fetcher.url_prefix).to eq('')
    end
  end

  context 'when target is a hash' do
    before :each do
      Chef::Config[:chef_server_url] = 'http://127.0.0.1:8889/organizations/org'
      allow(Chef).to receive(:node).and_return(mynode)
    end

    it 'should resolve a target with a version' do
      mynode.default['audit']['fetcher'] = nil
      res = ChefServer::Fetcher.resolve(profile_hash)
      expect(res.target.request_uri).to eq(profile_hash_target)
    end
  end

  context 'when profile not found' do
    before :each do
      Chef::Config[:verify_api_cert] = false
      Chef::Config[:ssl_verify_mode] = :verify_none
      allow(Chef).to receive(:node).and_return(mynode)
    end

    it 'should raise error' do
      myproc = proc {
        config = {
          'server_type' => 'automate',
          'automate' => {
            'ent' => 'my_ent',
            'token_type' => 'dctoken',
          },
          'profile' => ['admin', 'linux-baseline', '2.0'],
        }

        Fetchers::Url.new('non_profile_url', config).send(:http_opts)
      }
      expect { myproc.call }.to raise_error(RuntimeError)
    end
  end
end
