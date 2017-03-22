# encoding: utf-8

# used by ChefSpec
if defined?(ChefSpec)

  ChefSpec.define_matcher :compliance_profile
  ChefSpec.define_matcher :inspec_gem

  def upload_compliance_profile(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:compliance_upload, :upload, resource_name)
  end

  def install_inspec_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:inspec_gem, :install, resource_name)
  end
end
