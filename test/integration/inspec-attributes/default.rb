# get most recent json-file output
json_file = command('ls -t /opt/kitchen/cache/cookbooks/audit/inspec-*.json').stdout.lines.first.chomp

# Ensure the control we expect is present and passed
controls = json(json_file).controls
attribute_control = controls.find { |x| x['code_desc'] == 'File /opt/kitchen/cache/attribute-file-exists.test should exist'}
attribute_control = {} if attribute_control.nil?

describe 'attribute control' do
  it 'status should be passed' do
    expect(attribute_control['status']).to eq('passed')
  end
end
