require_relative 'base'
module DictionaryBuilder
  #
  # Builds a Dictionary by simply using the words/features with the highest
  # frequency across the hole dataset.
  # This DictionaryBuilder does not need the label(== indication if data is correct)
  #
  # @author Andreas Eger
  #
  class DocumentFrequency
    attr_accessor :data, :count
    def initialize(data, count: 200)
      @data = data
      @count = count
    end
    #
    # generates the dictionary
    #
    # @return [Dictionary]
    def generate
      @dictionary = build_dictionary
    end

    def dictionary
      @dictionary ||= build_dictionary
    end

  private
    def tokenize
      data.flat_map(&:data)
    end

    def build_dictionary
      token = tokenize.
                group_by{|e| e}.
                sort_by{|a| [-a[1].size, a[0]]}.
                map(&:first)
      Dictionary.new token.first(count)
    end
  end
end
