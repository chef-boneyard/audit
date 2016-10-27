# encoding: utf-8

# used by ChefSpec
if defined?(ChefSpec)

  ChefSpec.define_matcher :compliance_profile

  def upload_compliance_profile(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:compliance_upload, :upload, resource_name)
  end
end
