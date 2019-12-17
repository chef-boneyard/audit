provides :inspec_gem
resource_name :inspec_gem

property :gem_name, String, name_property: true
property :version, String
property :source, String

default_action :install

action :install do
  # detect if installation is required
  compatible_version = compatible_with_client?(new_resource.version)
  installation_required = inspec_info.nil? || !new_resource.version.nil?

  # detect if the same version is already installed
  unless inspec_info.nil?
    installed_version = inspec_info.version.to_s
    Chef::Log.debug("Installed Chef-InSpec version: #{installed_version}")
    if new_resource.version == installed_version
      installation_required = false
      Chef::Log.info("inspec_gem: not installing Chef-InSpec. Requested version #{new_resource.version} already installed")
      return
    end
  end

  if installation_required && compatible_version
    Chef::Log.info("Installation of Chef-InSpec required: #{installation_required}")

    unless inspec_info.nil?
      converge_by 'uninstall all inspec and train gem versions' do
        uninstall_inspec_gem
      end
    end

    converge_by 'install given Chef-InSpec version' do
      install_inspec_gem(version: new_resource.version, source: new_resource.source)
    end
  elsif new_resource.version.nil?
    Chef::Log.info('inspec_gem: not installing Chef-InSpec. No Chef-Inspec version specified')
  elsif !compatible_version
    Chef::Log.warn("inspec_gem: not installing Chef-InSpec. Requested version #{new_resource.version} is not compatible with chef-client #{Chef::VERSION}")
  end
end

action_class do
  def install_inspec_gem(options)
    gem_source  = options[:source]
    gem_version = options[:version]

    gem_version = nil if gem_version == 'latest'

    # use inspec-core for recent inspec versions
    gem_name = use_inspec_core?(gem_version) ? 'inspec-core' : 'inspec'

    chef_gem gem_name do
      version gem_version unless gem_version.nil?
      unless gem_source.nil?
        clear_sources true
        include_default_source false if respond_to?(:include_default_source)
        source gem_source
      end
      compile_time false
      action :install
    end

    chef_gem 'inspec-core-bin' do
      version gem_version unless gem_version.nil?
      unless gem_source.nil?
        clear_sources true
        include_default_source false if respond_to?(:include_default_source)
        source gem_source
      end
      compile_time false
      action :install
      only_if { need_inspec_core_bin?(gem_version) }
    end
  end

  def compatible_with_client?(gem_version)
    # No version specified so they will get the latest
    return true if gem_version.nil?

    if chef_gte_15?
      # Chef-15 can only run with the version of inspec-core and train-core that's being bundled with
      # It's pinned here: grep "inspec-" /opt/chef/bin/chef-client
      Chef::Log.warn('inspec_gem: Chef Infra Client >= 15 detected, can only use the embedded InSpec gem!!!')
      false
    else
      # min version required to run the audit handler
      Gem::Requirement.new(['>= 1.25.1']).satisfied_by?(Gem::Version.new(gem_version))
    end
  end

  def chef_gte_15?
    Gem::Requirement.new('>= 15').satisfied_by?(Gem::Version.new(Chef::VERSION))
  end

  def use_inspec_core?(gem_version)
    return true if gem_version.nil? # latest version
    Gem::Requirement.new('>= 2.1.67').satisfied_by?(Gem::Version.new(gem_version))
  end

  # Inspec 4+ does not include inspec binaries and requires an additional gem
  def need_inspec_core_bin?(gem_version)
    return true if gem_version.nil? # latest version
    Gem::Requirement.new('>= 4').satisfied_by?(Gem::Version.new(gem_version))
  end

  def uninstall_inspec_gem
    chef_gem 'remove all inspec versions' do
      package_name 'inspec'
      action :remove
    end

    chef_gem 'remove all inspec-core versions' do
      package_name 'inspec-core'
      action :remove
    end

    chef_gem 'remove all inspec-core-bin versions' do
      package_name 'inspec-core-bin'
      action :remove
    end

    chef_gem 'remove all train versions' do
      package_name 'train'
      action :remove
    end

    chef_gem 'remove all train-core versions' do
      package_name 'train-core'
      action :remove
    end
  end

  def inspec_info
    require 'rubygems'
    Gem::Specification.find { |s| %w(inspec inspec-core).include?(s.name) }
  rescue LoadError
    nil
  end
end
