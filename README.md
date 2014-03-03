# Text Classifiaction Helper

This more generalized version of svm helper plans to be more flexible in terms
of how it can be used as preprocessing steps for Text Classifcation methods.

[![Build Status](https://travis-ci.org/sch1zo/svm_helper.png?branch=generalization)](https://travis-ci.org/sch1zo/svm_helper)

## Installation

Add this line to your application's Gemfile:

    gem 'svm_helper', github: 'sch1zo/svm_helper', branch: 'generalization'

And then execute:

    $ bundle

## Usage

Dataflow is normally something like this:

    Job --Preprocessor--> PreprocessedData --Selector--> FeatureVector

The FeatureVector can now be used for training or prediction in a (libsvm) SVM.

Be aware that a FeatureVector has two Attributes:

    data: the feature array itself
    label: 1 for true, 0 for false

## External Data

The preprocessing and selections steps make use of stopword lists collected in
this [google project](https://code.google.com/p/stop-words/).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
