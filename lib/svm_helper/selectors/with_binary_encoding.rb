require_relative 'simple'
module Selector
  #
  # Selector which uses a n-gram dictionary to generate feature vectors
  #
  # @author Andreas Eger
  #
  class WithBinaryEncoding < Selector::Simple

    CLASSIFICATIONS_SIZE = {
          function: 8,        # max id 255, currently 19
          industry: 16,       # max id 65535, currently 14370
          career_level: 4 }   # max id 15, currently 8

    def initialize *args
      super
    end

    def label
      "simple-WithBinaryEncoding"
    end

    private
    #
    # creates the classification specific part of the feature vector
    # @param  ids [Hash] hash with classification ids
    #
    # @return [Array<Integer>] binary encoded classification id
    def classification_array(id)
      number_to_binary_array(id, CLASSIFICATIONS_SIZE[@classification])
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