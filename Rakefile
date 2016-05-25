#!/usr/bin/env rake

require 'foodcritic'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

CLEAN.include %w(.kitchen/ coverage/ doc/)
CLOBBER.include %w(Berksfile.lock Gemfile.lock .yardoc/)

# Default tasks to run when executing `rake`
task default: %w(lint)

# Style tests. Rubocop and Foodcritic
namespace :lint do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { fail_tags: ['any'] }
  end
end

desc 'Run all style checks'
task lint: ['lint:chef', 'lint:ruby']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

desc 'Find notes in code'
task :notes do
  puts `egrep --exclude=Rakefile --exclude=*.log -n -r -i '(TODO|FIXME|OPTIMIZE)' .`
end

namespace :test do
  task :integration do
    concurrency = ENV['CONCURRENCY'] || 1
    path = File.join(File.dirname(__FILE__), 'test', 'integration')
    sh('sh', '-c', "bundle exec kitchen test -c #{concurrency}")
  end
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

# Check the requirements for running an update of this repository.
def check_update_requirements
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

desc 'Generate the changelog'
task :changelog, [:version] do |_, args|
  v = args[:version] || ENV['to']
  fail "You must specify a target version!  rake changelog to=1.2.3" if v.empty?
  check_update_requirements
  system "github_changelog_generator -u chef-cookbooks -p audit --future-release #{v}"
end
