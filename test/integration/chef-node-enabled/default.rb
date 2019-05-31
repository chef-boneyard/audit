# get most recent json-file output
json_file = command('ls -t /tmp/inspec-*.json').stdout.lines.first.chomp
controls = json(json_file).profiles.first['controls']
results = []
controls.each do |c|
  c['results'].each do |r|
    results << r
  end
end

# Test ability to read in Chef node attributes when the chef_node attribute is enabled
cpu_key_control = results.find { |x| x['code_desc'] == 'Chef node data - cpu key should exist' }
cpu_key_control = {} if cpu_key_control.nil?

describe 'cpu_key control' do
  it 'status should be passed' do
    expect(cpu_key_control['status']).to eq('passed')
  end
end

chef_environment_control = results.find { |x| x['code_desc'] == 'Chef node data - chef_environment should exist' }
chef_environment_control = {} if chef_environment_control.nil?

describe 'chef_environment control' do
  it 'status should be passed' do
    expect(chef_environment_control['status']).to eq('passed')
  end
end
