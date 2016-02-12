require 'tempfile'
require 'uri'

# `compliance_profile` custom resource to collect and run Chef Compliance
# profiles
class ComplianceProfile < Chef::Resource
  use_automatic_resource_name

  property :profile, String, name_property: true
  property :owner, String, required: true

  # to use a chef-compliance server that is _not_ "colocated" with chef-server
  property :server, URI
  property :port, Integer
  property :username, String
  property :password, String
  property :token, String
  # TODO(sr) it might be nice to default to settings from attributes

  default_action :execute

  action :execute do
    converge_by 'install/update inspec' do
      chef_gem 'inspec' do
        compile_time true
      end
      require 'inspec'
    end

    converge_by 'fetch and execute compliance profile' do
      path = construct_url
      rest = Chef::ServerAPI.new
      tf = rest.binmode_streaming_request(path)

      inspec = ::Inspec::Runner.new('report' => true)
      inspec.add_tests([tf.path])
      exitcode = inspec.run
      # puts "inspec run exited with #{exitcode}"

      tf.unlink

      # handle inspec.report
      puts inspec.report
    end
  end

  def construct_url
    # defaults
    pname = profile
    if pname.include?('/')
      owner, pname = pname.split('/')
    else
      owner ||= 'base'
    end

    if token # does this work?!
      username = token
      password = nil
    end

    if server # get directly from compliance
      # optional overrides
      server.user = username if username
      server.password = password if password
      server.port = port if port

      server.path = "/owners/#{owner}/compliance/#{pname}/tar"
      server
    else # stream through chef-server
      chef = Chef::Config[:chef_server_url]
      URI.parse("#{chef}/gate/compliance/owners/#{owner}/compliance/#{pname}/tar")
    end
  end
end

