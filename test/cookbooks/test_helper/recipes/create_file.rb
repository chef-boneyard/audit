# ensures that the file defined by attributes exists, so its associated profile will pass
file_path = node['audit']['inputs']['test_file_path'] || node['audit']['attributes']['test_file_path']

file file_path do
  action :create
end
