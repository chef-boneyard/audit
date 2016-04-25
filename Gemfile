source 'https://rubygems.org'

gem 'chef', '>= 12.0'

group :style do
  gem 'foodcritic', '~> 6.0'
  gem 'rubocop', '~> 0.36.0'
end

group :test do
  gem 'rake', '~> 10'
  gem 'chefspec',  '~> 4.3.0'
  gem 'coveralls', '~> 0.8.2', require: false
end

group :integration do
  gem 'berkshelf', '~> 3.3.0'
  gem 'test-kitchen', '~> 1.6'
  gem 'kitchen-dokken'
  gem 'kitchen-inspec', '~> 0.9'
end

group :release do
  gem 'stove'
end
