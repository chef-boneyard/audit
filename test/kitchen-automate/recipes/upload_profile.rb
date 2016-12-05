
# Download this profile locally and trigger the upload
remote_file '/root/ssh-hardening.tar.gz' do
  source 'https://github.com/dev-sec/tests-ssh-hardening/archive/2.0.0.tar.gz'
  action :create
  notifies :run, 'ruby_block[upload_profile]', :immediately
end

# Upload '/root/ssh-hardening.tar.gz' to the local asset store using
# the Automate Asset Store API and the shared token
ruby_block 'upload_profile' do
  block do
    require 'json'
    require 'openssl'
    require 'net/http'

    http = Net::HTTP.new('localhost', 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new('/compliance/profiles/admin')

    file_path = '/root/ssh-hardening.tar.gz'
    req.body_stream=File.open(file_path, 'rb')
    req.add_field('Content-Length', File.size(file_path))
    req.add_field('Content-Type', 'application/x-gtar')

    req.add_field('x-data-collector-auth', 'version=1.0')
    req.add_field('chef-delivery-enterprise', 'default')
    req.add_field('x-data-collector-token', dc_token)

    boundary = 'INSPEC-PROFILE-UPLOAD'
    req.add_field('session', boundary)
    res=http.request(req)
  end
  action :nothing
end
