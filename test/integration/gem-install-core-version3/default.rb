# verify that a specific inspec version is installed
describe gem('inspec-core', :chef) do
  it { should be_installed }
  its('version') { should cmp '3.0.9' }
end

describe gem('inspec', :chef) do
  it { should_not be_installed }
end
