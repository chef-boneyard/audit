# Check the requirements for running an update of this repository.
task :check_update_dependencies do
  require_command 'git'
  require_command 'github_changelog_generator', "\n"\
    "For more information on how to install it see:\n"\
    "  https://github.com/skywinder/github-changelog-generator\n"
  require_env 'CHANGELOG_GITHUB_TOKEN', "\n"\
    "Please configure this token to make sure you can run all commands\n"\
    "against GitHub.\n\n"\
    "See github_changelog_generator homepage for more information:\n"\
    "  https://github.com/skywinder/github-changelog-generator\n"
end

# Check if a command is available
#
# @param [Type] x the command you are interested in
# @param [Type] msg the message to display if the command is missing
def require_command(x, msg = nil)
  return if system("command -v #{x} || exit 1")
  msg ||= 'Please install it first!'
  puts "\033[31;1mCan't find command #{x.inspect}. #{msg}\033[0m"
  exit 1
end

# Check if a required environment variable has been set
#
# @param [String] x the variable you are interested in
# @param [String] msg the message you want to display if the variable is missing
def require_env(x, msg = nil)
  exists = `env | grep "^#{x}="`
  return unless exists.empty?
  puts "\033[31;1mCan't find environment variable #{x.inspect}. #{msg}\033[0m"
  exit 1
end

begin
  require 'chef/cookbook/metadata'
  require 'github_changelog_generator/task'

  metadata = Chef::Cookbook::Metadata.new
  metadata.from_file('metadata.rb')

  GitHubChangelogGenerator::RakeTask.new changelog: ['check_update_dependencies'] do |config|
    # Just have to add a v here because its the convention stove uses
    config.future_release = "v#{metadata.version}"
    config.user = 'chef-cookbooks'
    config.project = 'audit'
    config.bug_labels = %w{bug Bug Type:\ Bug  }
    config.enhancement_labels = %w{enhancement Enhancement Type:\ Enhancement  }
  end
rescue LoadError
  puts 'Problem loading gems please install chef and github_changelog_generator'
end
