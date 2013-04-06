module Selector
  #
  # Selector which uses a simple dictionary to generate feature vectors
  #
  # @author Andreas Eger
  #
  class Simple
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

    def label
      "simple"
    end

    #
    # generates a list of feature vetors and their labels from preprocessed data
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  dictionary_size [Integer] Size of a dictionary to create if non exists
    #
    # @return [Array<FeatureVector>] list of feature vectors and labels
    def generate_vectors data_set, dictionary_size=DEFAULT_DICTIONARY_SIZE
      words_per_data = extract_words data_set
      generate_global_dictionary words_per_data, dictionary_size

      p_map_with_index(words_per_data) do |words,index|
        word_set = words.uniq
        make_vector word_set, data_set[index]
      end
    end

    #
    # generates a feature vector with its label
    # @param  data [PreprocessedData]
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  dictionary [Array] dictionary to use for this selection
    #
    # @return [FeatureVector]
    def generate_vector data, dictionary=global_dictionary
      word_set = Set.new extract_words_from_data(data)
      make_vector word_set, data, dictionary
    end

    #
    # generates a list of words used as dictionary
    # @param  all_words (see #extract_words)
    # @param  size dictionary size
    #
    # @return [Array<String>] list of words
    def generate_global_dictionary all_words, size=DEFAULT_DICTIONARY_SIZE
      return unless global_dictionary.empty?

      words = all_words.flatten.group_by{|e| e}.values
               .sort_by{|e| e.size}
               .map{|e| [e[0],e.size]}
      @global_dictionary = words.last(size).map(&:first).reverse
    end

    def build_dictionary data_set, dictionary_size=DEFAULT_DICTIONARY_SIZE
      words_per_data = extract_words data_set
      generate_global_dictionary words_per_data, dictionary_size
    end
    #
    # extracts the words of all provided data entries
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    #
    # @return [Array<Array<String>>] list of words per data entry
    def extract_words data_set
      data_set.map do |data|
        extract_words_from_data data
      end
    end

    #
    # fetches all words from one data entry, removes stopwords and very short words
    # @param  data [PreprocessedData] preprocessed data entry
    #
    # @return [Array<String>] list of words
    def extract_words_from_data data
      words = (data.data.flat_map(&:split) - stopwords)
                  .delete_if { |e| e.size <= 2 }
      if gram_size > 1
        words = words.each_cons(@gram_size).map{|e| e.join " " }
      end
      words
    end

    #
    # fetches all words and two word phrases from one data entry, removes stopwords and very short words
    # @param  data [PreprocessedData] preprocessed data entry
    # @param  keep_label
    #
    # @return [OpenStruct<Array<String>,Boolean>] list of words
    def extract_words_from_data data, keep_label=false
      # assume the first token is the title an preserve it
      title, *words = data.data.flatten
      features =  case word_selection
                  when :grams
                    words.each_cons(@gram_size).map{|e| e.join " " }
                  when :grams1_2
                    words + words.each_cons(2).map{|e| e.join " " }
                  when :grams1_2_3
                    words +
                      words.each_cons(2).map{|e| e.join " " } +
                      words.each_cons(3).map{|e| e.join " " }
                  when :grams1_2_3_4
                    words +
                      words.each_cons(2).map{|e| e.join " " } +
                      words.each_cons(3).map{|e| e.join " " } +
                      words.each_cons(4).map{|e| e.join " " }
                  else
                    words
                  end
      features.unshift(title)
      return features unless keep_label
      OpenStruct.new(
        features: features,
        label: data.label
      )
    end

    def reset classification
      @global_dictionary = []
      @classification = classification
    end

    private

    #
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
    # @param  ids [Hash] hash with classification ids
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
