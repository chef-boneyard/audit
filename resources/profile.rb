provides :audit_profile
resource_name :audit_profile

property :profile_name, String, name_property: true
property :compliance, String
property :git, String
property :path, String
property :url, String
property :supermarket, String
property :version, String

action :add do
  # if no source is defined assumed that that the name is what we are using and
  # that we are pulling from compliance
  node.run_state['audit'] ||= { 'profiles': {} }

  profile_name = new_resource.profile_name

  source_properties.each do |prop|
    next unless property_is_set?(prop.to_sym)
    add_profile({ "name" => profile_name, prop.to_s => new_resource.send(prop.to_sym) })
    break # for now we just quit out because we don't want to add the profile multiple times
  end
  # TODO: check to make sure we set something and throw an error if not
  # TODO: Determine if we should throw an error if more than one source is defined
end

action_class do
  def add_profile(profile)
    # make sure we have the initial run_state set for audit to work
    audit_config 'default' do
      action :init
    end

    profile_index = node.run_state['audit']['profiles'].index { |p| p['name'] == profile['name'] }

    if profile_index.nil?
      node.run_state['audit']['profiles'] << profile
    else
      log "Skipped adding profile #{profile["name"]}, already added"
    end
  end

  # properties that might contain source info for the profile
  def source_properties
    %w{ compliance git path url supermarket }
  end
end
