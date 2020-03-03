# get most recent json-file output
json_file = command('ls -t /tmp/inspec-*.json').stdout.lines.first.chomp
controls = json(json_file).profiles.first['controls']

# The test fixture has two controls - the first should pass,
# the second should be a skip with a waiver justification

control 'the unwaivered control' do
  describe controls[0]['results'][0]['status'] do
    it { should cmp 'passed' }
  end
end

control 'the waivered control' do
  describe controls[1]['results'][0]['status'] do
    it { should cmp 'skipped' }
  end
end
