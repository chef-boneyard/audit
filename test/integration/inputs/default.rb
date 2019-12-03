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
input_control = results.find { |x| x['code_desc'] == 'File /opt/kitchen/cache/file-exists.test is expected to exist' }
input_control = {} if input_control.nil?

describe 'input control' do
  it 'status should be passed' do
    expect(input_control['status']).to eq('passed')
  end
end
