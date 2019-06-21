audit_profile 'ssh-baseline' do
  supermarket 'dev-sec/ssh-baseline'
end

# this one will be skipped because it was already added by the previous one
audit_profile 'ssh-baseline' do
  compliance 'admin/ssh-baseline'
end
