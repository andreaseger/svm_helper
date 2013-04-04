# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svm_helper/version'

Gem::Specification.new do |gem|
  gem.name          = "svm_helper"
  gem.version       = SvmHelper::VERSION
  gem.authors       = ["Andreas Eger"]
  gem.email         = ["dev@eger-andreas.de"]
  gem.description   = %q{Shared helper classes for usage in context of SVM at experteer}
  gem.summary       = %q{Preprocessor and Selector classes to generate FeatureVectors from Job data}
  gem.homepage      = "https://github.com/sch1zo/svm_helper"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "fast-stemmer"
end
