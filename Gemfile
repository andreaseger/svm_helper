source 'https://rubygems.org'

# Specify your gem's dependencies in svm_helper.gemspec
gemspec

gem 'ruby-stemmer', require: false, platform: :ruby
gem 'jruby-stemmer', require: false, platform: :jruby

# gem 'racc', platform: :rbx
# gem 'rubysl', platform: :rbx

group :development do
  gem 'yard'
  gem 'kramdown'
  gem 'github-markup'

  gem 'pry'
  gem 'guard-rspec'
  gem 'guard-yard'
  gem 'rubocop', require: false, platform: :ruby

  gem 'rb-inotify', '~> 0.9', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'rake'
  gem 'rspec'
  gem 'factory_girl', '~> 4.0'
  gem 'parallel', require: false
  #fixed version because of known bug see https://github.com/colszowka/simplecov
  gem 'simplecov', '~> 0.7.1', require: false
end
