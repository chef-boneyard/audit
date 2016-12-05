# encoding: utf-8
#
# Cookbook Name:: compliance
# Spec:: inspec
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

describe 'audit::inspec' do
  context 'When a package install is specified' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.override['audit']['inspec_package']['source'] = 'http://path/to/fake.rpm'
        node.override['audit']['inspec_package']['libpath'] = 'bla'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    context 'and a required attribute (node[\'audit\'][\'inspec_package\'][\'libpath\']) is missing' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.override['audit']['inspec_package']['source'] = 'http://path/to/fake.rpm'
          node.override['audit']['inspec_package']['libpath'] = nil
        end.converge(described_recipe)
      end

      it 'raises an error' do
        expect { chef_run }.to raise_error(RuntimeError)
      end
    end
  end
end