#Goals of this refactoring:

- find better names for stuff to avoid confusion, some suggestions
  - dictionary => bag_of_words
  - preprocessor => tokenizer
  - gem-name => rselect, rnlp, nlp-tools

- Can work on any kind of text dataset which is labeled acording to a one-class
classifiaction problem. This means a data entry is either in the class(true) or
not (false)

- regain compatability with jruby
- make ruby-stemmer optional as it is a c-extention, handle missing of that gem
  accordingly.
- jruby compatability should also mean 1.9 compatability
- look into changes necessary for supporting rbx

## stuff to think about

### multi-label feature vector

meaning I don't have just true/false as labels for the texts, but I have one of
N categories or similar.

- how can I use the feature selection algorithms in that case
- whats the best encoding for the category, also see [this](ftp://ftp.sas.com/pub/neural/FAQ2.html#A_cat)
- fselector gem(uses R to make the heavy math lifting)

### verification vs classification

verification can always be transformed in a one-class problem, but what is the
best encoding for the category within the feature vector.

- binary
- bitmap
- [this](ftp://ftp.sas.com/pub/neural/FAQ2.html#A_cat)

### clustering

can the feature vectors produced here be used in clustering?
what additional requirements would that involve?

- [k-means clustering in ruby](http://colinfdrake.com/2011/05/28/clustering-in-ruby.html)
- document frequency can more or less directly be used to make a dictionary

## other stuff to have a closer look at

- [Artificial Intelligence for Ruby](http://www.ai4r.org/)
- [Fast Artificial Neuronal Network Library](http://leenissen.dk/fann/wp/)
- [Ruby FANN](https://github.com/tangledpath/ruby-fann)
