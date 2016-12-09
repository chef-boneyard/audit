package 'at' do
  action :install
end

service 'atd' do
  action [ :enable, :start ]
end

# Run the "halt" command on the instance 4 hours from now
# Ensures instances are not left hanging around if integration tests fail
# To prevent an instance from halting use the `atq` and `atrm ID` commands as root
execute 'echo "halt" | at now + 50 minutes' do
  action :run
end
