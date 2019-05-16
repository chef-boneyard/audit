# verify that a specific inspec version is installed
describe gem('inspec', :chef) do
  it { should_not be_installed }
end

describe gem('inspec-core', :chef) do
  it { should be_installed }
  its('version') { should_not cmp '3.0.9' }
end
