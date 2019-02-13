provides :audit_config
resource_name :audit_config

property :profiles, [Array, Hash], default: lazy { node['audit']['profiles'] }

action :run do
  setup_run_state
end

# This is used by the other resource to ensure that our runstate is configured
# without having to handle all the other audit config setup we will eventually
# need
action :init do
  setup_run_state
end

action_class do
  # We need to check to see if the profiles is an Hash of Hashes and needs to
  # be upgraded to an Array of Hashes
  # The reason this might be a hash is to support `include_policy` in
  # PolicyFiles setting profiles to run
  def get_profile_list
    return new_resource.profiles.dup if new_resource.profiles.is_a?(Array)
    update_to_array(new_resource.profiles.dup)
  end

  def update_to_array(profiles)
    log "Current profile list is a Hash, converting to an array: #{profiles.inspect}"

    profiles.keys.inject([]) do |c,name|
      profile = profiles[name]
      profile['name'] = name
      c << profile
      c
    end
  end

  # store current profile list in the run_state
  def setup_run_state
    node.run_state['audit'] ||= { 'profiles' => get_profile_list }
  end
end
