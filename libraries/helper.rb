module ComplianceHelpers
  # rubocop:disable all
  def construct_url(url)
    if token # does this work?!
      username = token
      password = nil
    end

    if server && server.is_a?(URI) # get directly from compliance
      puts "self: #{self.inspect}"
      # optional overrides
      server.user = username if username
      server.password = password if password
      server.port = port if port
      server.path = server.path + url if url
      server
    else # stream through chef-server
      chef = Chef::Config[:chef_server_url]
      u = "#{chef}/compliance/" +  url if url
      URI.parse(u)
    end
  end
end
