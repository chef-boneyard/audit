# ensures that the file defined by attributes exists, so its associated profile will pass

file node['audit']['inputs']['test_file_path'] do
  action :create
end
