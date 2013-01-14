require_relative '../interfaces'
module Selector
  #
  # Selector which uses a simple dictionary to generate feature vectors
  #
  # @author Andreas Eger
  #
  class Simple
    # stopword file
    STOPWORD_LOCATION = File.join(File.dirname(__FILE__),'..','stopwords')
    # default dictionary size
    DEFAULT_DICTIONARY_SIZE = 5000

    CLASSIFICATIONS_SIZE= if defined?(Pjpp) == 'constant'
                            { function: Pjpp::Function.count,
                              industry: Pjpp::Industry.count,
                              career_level: Pjpp::CareerLevel.count }
                          else
                            { function: 19,       # 1..19
                              industry: 632,      # 1..14370 but not all ids used
                              career_level: 8 }   # 1..8
                          end

    attr_accessor :global_dictionary
    attr_accessor :classification

    def initialize args={}
      @global_dictionary = args.fetch(:global_dictionary) {[]}
    end

    #
    # generates a list of feature vetors and their labels from preprocessed data
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  dictionary_size [Integer] Size of a dictionary to create if non exists
    #
    # @return [Array<FeatureVector>] list of feature vectors and labels
    def generate_vectors data_set, classification, dictionary_size=DEFAULT_DICTIONARY_SIZE
      @classification = classification
      words_per_data = extract_words data_set
      generate_global_dictionary words_per_data, dictionary_size

      words_per_data.map.with_index{|words,index|
        word_set = words.uniq
        make_vector word_set,
                    data_set[index].send("#{classification.to_s}_id"),
                    data_set[index].label
      }
    end

    #
    # generates a feature vector with its label
    # @param  data [PreprocessedData]
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  dictionary [Array] dictionary to use for this selection
    #
    # @return [FeatureVector]
    def generate_vector data, classification, dictionary=global_dictionary
      @classification = classification
      word_set = Set.new extract_words_from_data(data)
      make_vector word_set, data.send("#{classification.to_s}_id"), data.label, dictionary
    end

    #
    # loads a txt file with stop words
    # @param  language String either 'de' or 'en'
    # @param  location String folder with stopword lists
    #
    # @return [Array<String>] Array of stopwords
    def stopwords(language='de',location=STOPWORD_LOCATION)
      @stopwords ||= IO.read(File.join(location,language)).split
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
      (data.data.flat_map(&:split) - stopwords).delete_if { |e| e.size <= 3 }
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
    # @param  classification_id [Integer] classification id given for the data entry
    # @param  label [Boolean] was that classi
    # @param  dictionary
    #
    # @return [FeatureVector]
    def make_vector words, classification_id, label, dictionary=global_dictionary
      FeatureVector.new(
        data: dictionary.map{|dic_word|
                words.include?(dic_word) ? 1 : 0
              }.concat(classification_array(classification_id)),
        label: label ? 1 : 0
      )
    end

    #
    # creates the classification specific part of the feature vector
    # @param  id [Integer] classification_id
    #
    # @return [Array<Integer>] list of size=count(classifcation_ids) with only one not zero item
    def classification_array(id)
      Array.new(CLASSIFICATIONS_SIZE[classification.to_sym]){|n| n==(id-1) ? 1 : 0}
    end
  end
end