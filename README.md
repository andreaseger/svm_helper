# Text Classifiaction Helper

This more generalized version of svm helper plans to be more flexible in terms
of how it can be used as preprocessing steps for Text Classifcation methods.

[![Build Status](https://travis-ci.org/sch1zo/svm_helper.png?branch=generalization)](https://travis-ci.org/sch1zo/svm_helper)

## Installation

Add this line to your application's Gemfile:

    gem 'svm_helper', github: 'sch1zo/svm_helper', branch: 'generalization'

And then execute:

    $ bundle

## ToDo

- extract dictionary creation from selectors into DictionaryBuilder classes
- integrate stopwords from this [google project](https://code.google.com/p/stop-words/)
- remove last bits of PJPP linkage
- rename gem / find better gem name
- wrap everything into namespace ^^
- improve structure under lib
- cleanup / improve preprocessor structure/code
- write proper usage guide
- add example script(s) regarding how to use everything
- some benchmarking - both memory and speed

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
