source 'https://rubygems.org'

gem 'chef', '>= 12.5.1'

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2')
  gem 'json', '~> 1.8'
  gem 'rack', '< 2.0'
  gem 'fauxhai', '< 3.10'
end

group :style do
  gem 'foodcritic', '~> 7.0'
  gem 'cookstyle'
end

group :test do
  gem 'rake', '>= 11.3'
  gem 'berkshelf', '>= 5.0'
  gem 'chefspec',  '>= 5.2'
  gem 'coveralls', '~> 0.8.2', require: false
end

group :integration do
  gem 'test-kitchen', '~> 1.13'
  gem 'kitchen-dokken'
  gem 'kitchen-ec2', '~> 1.2'
  gem 'kitchen-inspec', '~> 0.15'
end

group :release do
  gem 'github_changelog_generator', '~> 1'
  gem 'stove'
end
