# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svm_helper/version'

Gem::Specification.new do |gem|
  gem.name          = 'svm_helper'
  gem.version       = SvmHelper::VERSION
  gem.authors       = ['Andreas Eger']
  gem.email         = ['dev@eger-andreas.de']
  gem.description   = %q(helper classes to create FeatureVectors from text)
  gem.summary       = <<-EOF.gsub(/^ +/, '')
                      Helpers for preprocessing text, build dictionaries from
                      training data and create feature vectors based on a
                      dictionary
                      EOF
  gem.homepage      = 'https://github.com/sch1zo/svm_helper'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
