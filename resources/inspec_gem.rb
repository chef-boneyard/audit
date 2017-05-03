provides :inspec_gem
resource_name :inspec_gem

property :gem_name, String, name_property: true
property :version, String
property :source, String

default_action :install

action :install do
  # detect if installation is required
  installation_required = inspec_info.nil? || !version.nil?

  # detect if the same version is already installed
  if !inspec_info.nil?
    installed_version = inspec_info.version.to_s
    Chef::Log.debug("Installed InSpec version: #{installed_version}")
    installation_required = false if version == installed_version
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
      install_inspec_gem(version: version, source: source)
    end
  else
    Chef::Log.info("inspec_gem: not installing InSpec. It's already installed or an explicit version was not supplied.")
  end
end

action_class do
  def install_inspec_gem(options)
    gem_source  = options[:source]
    gem_version = options[:version]

    chef_gem 'inspec' do
      version gem_version if !gem_version.nil? && gem_version != 'latest'
      clear_sources true unless gem_source.nil?
      source gem_source unless gem_source.nil?
      action :install
    end
  end

  def uninstall_inspec_gem
    chef_gem 'remove all inspec versions' do
      package_name 'inspec'
      action :remove
    end

    chef_gem 'remove all train versions' do
      package_name 'train'
      action :remove
    end
  end

  def inspec_info
    require 'rubygems'
    Gem::Specification.find_by_name('inspec')
  rescue LoadError
    nil
  end
end
