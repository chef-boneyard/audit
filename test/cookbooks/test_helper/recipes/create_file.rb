# ensures that the file defined by attributes exists, so its associated profile will pass

file node['audit']['attributes']['file'] do
  action :create
end
