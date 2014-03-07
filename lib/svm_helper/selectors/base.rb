module Selector
  #
  # Base class for the selector functionallity
  #
  # @author Andreas Eger
  #
  class Base
    include ::ParallelHelper
    # default dictionary size
    DEFAULT_DICTIONARY_SIZE = 800

    attr_accessor :global_dictionary
    attr_reader :classification_encoding,
                :gram_size,
                :word_selection

    def initialize classification, args={}
      @classification = classification
      @global_dictionary = args.fetch(:global_dictionary) {[]}
      @classification_encoding = args.fetch(:classification_encoding){:bitmap}
      @word_selection = args.fetch(:word_selection){ :single }
      @gram_size = args.fetch(:gram_size) { 1 }
      @parallel = args.fetch(:parallel){false}
    end

    #
    # generates a list of feature vetors and their labels from preprocessed data
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  dictionary_size [Integer] Size of a dictionary to create if non exists
    #
    # @return [Array<FeatureVector>] list of feature vectors and labels
    def generate_vectors data_set, dictionary_size=DEFAULT_DICTIONARY_SIZE
      words_per_data = extract_words data_set
      generate_global_dictionary words_per_data, dictionary_size

      p_map_with_index(words_per_data) do |words,index|
        word_set = Set.new(words)
        make_vector word_set, data_set[index]
      end
    end

    #
    # generates a feature vector with its label
    # @param  data [PreprocessedData]
    # @param  dictionary [Array] dictionary to use for this selection
    #
    # @return [FeatureVector]
    def generate_vector data, dictionary=global_dictionary
      word_set = Set.new extract_words_from_data(data)
      make_vector word_set, data, dictionary
    end

  private

    # creates a feature vector for the given words, classification and dictionary
    # also adds the label
    # @param  words [Array<String>] list of words
    # @param  data [PreprocessedData]
    # @param  dictionary
    #
    # @return [FeatureVector]
    def make_vector words, data, dictionary=global_dictionary
      FeatureVector.new(
        word_data: dictionary.map{|dic_word|
                     words.include?(dic_word) ? 1 : 0
                   },
        classification: classification_array(data.id),
        label: data.label ? 1 : 0
      )
    end

  ##############################################################################
  # encode classifiaction
  ##############################################################################
    BITMAP_ARRAY_SIZES= if defined?(Pjpp) == 'constant'
                            { function: Pjpp::Function.count,
                              industry: Pjpp::Industry.count,
                              career_level: Pjpp::CareerLevel.count }
                          else
                            { function: 19,       # 1..19
                              industry: 632,      # 1..14370 but not all ids used
                              career_level: 8 }   # 1..8
                          end

    BINARY_ARRAY_SIZES = {
            function: 8,        # max id 255, currently 19
            industry: 16,       # max id 65535, currently 14370
            career_level: 4 }   # max id 15, currently 8
    #
    # creates the classification specific part of the feature vector
    # @param  id [Hash] hash with classification ids
    #
    # @return [Array<Integer>] list of size=count(classifcation_ids) with only one not zero item
    def classification_array(id)
      case @classification_encoding
      when :binary
        number_to_binary_array(id, BINARY_ARRAY_SIZES[@classification])
      else # :bitmap
        Array.new(BITMAP_ARRAY_SIZES[@classification]){|n| n==(id-1) ? 1 : 0}
      end
    end

    def number_to_binary_array(number, size=8)
      a=[]
      (size-1).downto(0) do |i|
        a<<number[i]
      end
      a
    end
  end
end