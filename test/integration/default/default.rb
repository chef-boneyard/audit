# encoding: utf-8
# copyright: 2015, The Authors
# license: All rights reserved

unless os.linux?
  STDERR.puts "\033[1;33mTODO: Not running #{__FILE__} because we are not on Linux.\033[0m"
  return
end

node = json('/tmp/node.json')

# TODO: change once gem resource handles alternate path to `gem` command
describe command('/opt/chef/embedded/bin/gem list --local -a -q inspec | grep \'^inspec\' | awk -F"[()]" \'{printf $2}\'') do
  its('stdout') { should_not be_nil }
end

command('find /opt/kitchen/cache/cookbooks/audit -type f -a -name inspec\*.json').stdout.split.each do |f|
  describe json(f.to_s) do
    its(['statistics','duration']) { should be < 10 }
  end
end
