require_relative 'simple'
module Selector
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  class BiNormalSeperation < Selector::Simple
    include BagOfWords
    include BNS

    # nice printable label for this selector
    def label
      "BiNormalSeperation"
    end

    def initialize classification, args={}
      super
      @word_selection = args.fetch(:word_selection){ :grams1_2 }
    end
    #
    # generates a list of feature vetors and their labels from preprocessed data
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  dictionary_size [Integer] Size of a dictionary to create if non exists
    #
    # @return [Array<FeatureVector>] list of feature vectors and labels
    def generate_vectors data_set, dictionary_size=DEFAULT_DICTIONARY_SIZE
      words_and_label_per_data = extract_words data_set, true
      generate_global_dictionary words_and_label_per_data, dictionary_size

      words_per_data = words_and_label_per_data.map(&:features)
      p_map_with_index(words_per_data) do |words,index|
        word_set = words.uniq
        make_vector word_set, data_set[index]
      end
    end

    #
    # generates a list of words used as dictionary
    # @param  all_words (see #extract_words)
    # @param  size dictionary size
    #
    # @return [Array<String>] list of words
    def generate_global_dictionary all_words, size=DEFAULT_DICTIONARY_SIZE
      return unless global_dictionary.empty?

      features, pos, neg = make_bag(all_words)

      words = p_map(features) do |word, counts|
                next if counts.any? { |e| e==0 } # skip words only appearing in one class
                bns = bi_normal_seperation(pos, neg, *counts)
                [word, bns.abs]
              end
      @global_dictionary = words.compact
                                .sort_by{|e| e[1]}
                                .last(size)
                                .map{|e| e[0] }
    end

    def build_dictionary data_set, dictionary_size=DEFAULT_DICTIONARY_SIZE
      words_per_data = extract_words data_set, true
      generate_global_dictionary words_per_data, dictionary_size
    end
    #
    # extracts the words of all provided data entries
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  keep_label
    #
    # @return [Array<OpenStruct<Array<String>,Boolean>>] list of words per data entry
    def extract_words data_set, keep_label=false
      data_set.map do |data|
        extract_words_from_data data, keep_label
      end
    end
  end
end
