module SvmHelper
  module DictionaryBuilder
    #
    # Base class for dictionary builders
    #
    # @author Andreas Eger
    #
    class Base
      include ParallelHelper
      attr_accessor :data, :count

      #
      # @param  data [Array<String>] tokenized text
      # @param  count: 200 [Integer] size of the dictionary
      def initialize data, count: 200
        @data = data
        @count = count
      end
      #
      # generates the dictionary
      #
      # @return [Dictionary]
      def generate count: @count
        @count = count
        @dictionary = build_dictionary
      end

      #
      # getter for dictionary, builds dictionary on demand
      # @return [Dictionary]
      def dictionary
        @dictionary ||= build_dictionary
      end

    private

      def build_dictionary
        tokens = data.map{ |e| { token: e.token.flatten, correct: e.correct } }
        features, pos, neg = make_bag(tokens)

        words = p_map(features) do |word, counts|
          next if counts.any?(&:zero?) # skip words only appearing in one class
          tp, fp = counts
          [word, fitness(pos, neg, tp, fp)]
        end

        words_to_dictionary words
      end

      def words_to_dictionary words
        Dictionary.new words.
                       compact.
                       sort_by{ |a| [-a[1], a[0]] }.
                       first(count).
                       map(&:first)
      end

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
      # @return [Hash, Integer, Integer] Hash of apperence count of words per
      #                                  label + number of positiv and negativ
      #                                  vectors
      def make_bag all_words
        count_per_label = [0, 0] # there is only true of false

        accumulator = Hash.new{ |h, k| h[k] = [0, 0] }
        all_words.each do |data|
          label = data[:correct] ? 1 : 0
          count_per_label[label] += 1
          # only count a feature once per data
          data[:token].uniq.each do |word|
            # increment count for the current word and the label of this data
            accumulator[word][label] += 1
          end
        end
        [accumulator, *count_per_label]
      end
    end
  end
end
