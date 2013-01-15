# SvmHelper

Shared helper classes for usage in context of SVM at experteer

[![Build Status](https://travis-ci.org/sch1zo/svm_helper.png?branch=master)](https://travis-ci.org/sch1zo/svm_helper)

## Installation

Add this line to your application's Gemfile:

    gem 'svm_helper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svm_helper

## Usage

Dataflow is normally something like this:

    Job --Preprocessor--> PreprocessedData --Selector--> FeatureVector

The FeatureVector can now be used for training or prediction in a (libsvm) SVM.

Be aware that a FeatureVector has two Attributes:

    data: the feature array itself
    label: 1 for true, 0 for false


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
