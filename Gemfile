source 'https://rubygems.org'

gem 'chef', '>= 12.5.1'

group :style do
  gem 'foodcritic', '~> 11.0'
  gem 'cookstyle', '~> 1.3'
end

group :test do
  gem 'rake', '>= 11.3'
  gem 'berkshelf', '>= 5.6'
  gem 'chefspec',  '~> 7.0'
  gem 'coveralls', '~> 0.8.2', require: false
  gem 'rb-readline'
  gem 'webmock'
  gem 'fauxhai', '~> 5.2'
end

group :integration do
  gem 'test-kitchen', '~> 1.16'
  gem 'kitchen-dokken', '= 2.6.0'
  gem 'kitchen-ec2', '~> 1.2'
  gem 'kitchen-inspec', '~> 0.18'
end

group :release do
  gem 'github_changelog_generator', '~> 1'
  gem 'stove'
end
