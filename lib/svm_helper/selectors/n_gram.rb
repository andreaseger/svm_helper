require_relative 'simple'
module Selector
  #
  # Selector which uses a n-gram dictionary to generate feature vectors
  #
  # @author Andreas Eger
  #
  class NGram < Selector::Simple
    attr_reader :gram_size

    def initialize args={}
      super
      @gram_size = args.fetch(:gram_size) { 2 }
    end

    #
    # fetches all words snippets from one data entry, removes stopwords and very short words
    # @param  data [PreprocessedData]
    # @param  gram_size [Integer] gram size
    #
    # @return [Array<String>]
    def extract_words_from_data data, gram_size=@gram_size
      (data.data.flat_map(&:split) - stopwords)
                .delete_if { |e| e.size <= 3 }
                .each_cons(gram_size).map{|e| e.join " " }
    end
  end
end