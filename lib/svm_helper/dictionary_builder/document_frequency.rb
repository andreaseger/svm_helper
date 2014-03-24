require_relative "base"
module DictionaryBuilder
  #
  # Builds a Dictionary by simply using the words/features with the highest
  # frequency across the hole dataset.
  # This DictionaryBuilder does not need the label(== indication if data is correct)
  #
  # @author Andreas Eger
  #
  class DocumentFrequency < Base
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
      token = all_token.
                group_by{|e| e}.
                sort_by{|a| [-a[1].size,a[0]]}.
                map(&:first)
      @dictionary = Dictionary.new token.first(count)
    end
    def dictionary
      if @dictionary
        @dictionary
      else
        generate
        @dictionary
      end
    end
    private
    def all_token
      data.flat_map(&:data)
    end
  end
end