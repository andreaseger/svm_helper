require 'bundler'
Bundler.setup

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/_benchmarks/'
  add_filter '/spec/'
end

Bundler.require(:default, :test)

require 'svm_helper'
include SvmHelper

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir['./spec/support/**/*.rb'].each{|f| require f}

  FactoryGirl.find_definitions

  config.before(:each) do
    stub_const('SvmHelper::ParallelHelper::THREAD_COUNT', 0)
  end

end
