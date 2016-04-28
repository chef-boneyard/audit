# encoding: utf-8

# used by ChefSpec
if defined?(ChefSpec)

  ChefSpec.define_matcher :compliance_profile

  def fetch_compliance_profile(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:compliance_profile, :fetch, resource_name)
  end

  def execute_compliance_profile(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:compliance_profile, :execute, resource_name)
  end

  def execute_compliance_report(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:compliance_report, :execute, resource_name)
  end
end
