require_relative 'bi_normal_seperation'
module Selector
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  class BNS_IG < Selector::BiNormalSeperation
    include IG

    # printable label for this Selector
    def label
      "BiNormalSeperation_InformationGain"
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
                ig = information_gain(pos, neg, *counts)
                # use geometric mean of BNS and IG
                [word, Math.sqrt(bns.abs * ig.abs)]
              end
      @global_dictionary = words.compact
                                .sort_by{|e| e[1]}
                                .last(size)
                                .map{|e| e[0] }
    end
  end
end
