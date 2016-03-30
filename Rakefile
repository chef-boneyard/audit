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
