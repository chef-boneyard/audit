provides :inspec_gem
resource_name :inspec_gem

property :gem_name, String, name_property: true
property :version, String
property :source, String

default_action :install

action :install do
  # detect if installation is required
  installation_required = inspec_info.nil? || !new_resource.version.nil?

  # detect if the same version is already installed
  if !inspec_info.nil?
    installed_version = inspec_info.version.to_s
    Chef::Log.debug("Installed InSpec version: #{installed_version}")
    installation_required = false if new_resource.version == installed_version
  end
  Chef::Log.info("Installation of InSpec required: #{installation_required}")

  # only uninstall if InSpec is installed
  if installation_required && !inspec_info.nil?
    converge_by 'uninstall all inspec and train gem versions' do
      uninstall_inspec_gem
    end
  end

  if installation_required
    converge_by 'install latest InSpec version' do
      install_inspec_gem(version: new_resource.version, source: new_resource.source)
    end
  else
    Chef::Log.info("inspec_gem: not installing InSpec. It's already installed or an explicit version was not supplied.")
  end
end

action_class do
  def install_inspec_gem(options)
    gem_source  = options[:source]
    gem_version = options[:version]

    gem_version = nil if gem_version == 'latest'

    # use inspec-core for recent inspec versions
    if gem_version.nil? || (Gem::Version.new(gem_version) >= Gem::Version.new('2.1.67'))
      chef_gem 'inspec-core' do
        version gem_version unless gem_version.nil?
        unless gem_source.nil?
          clear_sources true
          include_default_source false if respond_to?(:include_default_source)
          source gem_source
        end
        action :install
      end
    else
      chef_gem 'inspec' do
        version gem_version unless gem_version.nil?
        unless gem_source.nil?
          clear_sources true
          include_default_source false if respond_to?(:include_default_source)
          source gem_source
        end
        action :install
      end
    end
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
    Gem::Specification.find { |s| ['inspec', 'inspec-core'].include?(s.name) }
  rescue LoadError
    nil
  end
end
