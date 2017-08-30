# get most recent json-file output
json_file = command('ls -t /opt/kitchen/cache/cookbooks/audit/inspec-*.json').stdout.lines.first.chomp
controls = json(json_file).controls

# the controls that read from chef_node should fail because the chef_node data should not be present
cpu_key_control = controls.find { |x| x['code_desc'] == 'Chef node data - cpu key should exist'}
cpu_key_control = {} if cpu_key_control.nil?

describe 'cpu_key control' do
  it 'status should be failed' do
    expect(cpu_key_control['status']).to eq('failed')
  end
end

chef_environment_control = controls.find { |x| x['code_desc'] == 'Chef node data - chef_environment should exist'}
chef_environment_control = {} if chef_environment_control.nil?

describe 'chef_environment control' do
  it 'status should be failed' do
    expect(chef_environment_control['status']).to eq('failed')
  end
end
