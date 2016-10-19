
handler_directory = ::File.join(Chef::Config[:file_cache_path], 'handler')

directory handler_directory do
  recursive true
  action :delete
end
