require_relative 'simple'
module Selector
  class Base < Simple

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
                next if counts.any?(&:zero?) # skip words only appearing in one class
                tp, fp = counts
                [word, fitness(pos, neg, tp, fp)]
              end
      @global_dictionary = words.compact
                                .sort_by{|e| e[1]}
                                .last(size)
                                .map(&:first)
    end

  private

    #
    # creates a Hash for all words which describes how often each word
    # appeared in each class
    #
    # the result hash will look something like this
    #
    #  ```
    # {
    #   "some" => [34,2],
    #   "words" => [35,6],
    #   "for" => [4,35],
    #   "each" => [23,12],
    #   "class" => [54,11],
    #   ...
    # }
    # ```
    #
    # @param all_words (see #extract_words)
    #
    # @return [Hash, Integer, Integer] Hash of apperence count of words per label + number of positiv and negativ vectors
    def make_bag all_words
      count_per_label = [0,0] # there is only true of false

      accumulator = Hash.new { |h, k| h[k] = [0,0] }
      all_words.each do |data|
        label = data.correct ? 1 : 0
        count_per_label[label] += 1
        # only count a feature once per data
        data.features.uniq.each do |word|
          # increment count for the current word and the label of this data
          accumulator[word][label] += 1
        end
      end
      [accumulator, *count_per_label]
    end
  end
end