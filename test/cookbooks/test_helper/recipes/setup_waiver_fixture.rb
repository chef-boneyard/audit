
%w(controls waivers).each do |subdir|
  directory "#{node['audit']['profiles']['waiver-test-profile']['path']}/#{subdir}" do
    recursive true
  end
end

%w(inspec.yml controls/waiver-check.rb waivers/waivers.yaml).each do |file|
  cookbook_file "#{node['audit']['profiles']['waiver-test-profile']['path']}/#{file}" do
    source "waivers-fixture/#{file}"
  end
end
