# get most recent json-file output
json_file = command('ls -t /tmp/inspec-*.json').stdout.lines.first.chomp

# ensure the control we expect is present and passed
controls = json(json_file).profiles.first['controls']
results = []
controls.each do |c|
  c['results'].each do |r|
    results << r
  end
end
attribute_control = results.find { |x| x['code_desc'] == 'File /opt/kitchen/cache/attribute-file-exists.test is expected to exist' }
attribute_control = {} if attribute_control.nil?

describe 'attribute control' do
  it 'status should be passed' do
    expect(attribute_control['status']).to eq('passed')
  end
end
