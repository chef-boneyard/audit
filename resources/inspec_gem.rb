provides :inspec_gem
resource_name :inspec_gem

property :gem_name, String, name_property: true
property :version, String
property :source, String

default_action :install

action :install do
  if !version.nil?
    converge_by 'uninstall all inspec and train gem versions' do
      uninstall_inspec_gem
    end
    converge_by "install requested inspec version #{version}" do
      install_inspec_gem(version: version, source: source)
    end
  elsif !inspec_installed?
    converge_by 'install latest InSpec version' do
      install_inspec_gem(source: source)
    end
  else
    Chef::Log.info("inspec_gem: not installing InSpec. It's already installed and an explicit version was not supplied.")
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

  def inspec_installed?
    require 'inspec'
    true
  rescue LoadError
    false
  end
end
