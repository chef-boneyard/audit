#inspec (1.16.1)

# verify that only inspec v1.16.1 is installed
describe command('/opt/chef/embedded/bin/gem list --local -a -q inspec | grep \'^inspec\' | awk -F"[()]" \'{printf $2}\'') do
  its('stdout') { should cmp '1.18.0' }
end
