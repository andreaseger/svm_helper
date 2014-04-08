require_relative 'base'
module Selector
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  class BNS_IG < Selector::Base
    # printable label for this Selector
    def label
      "BiNormalSeperation_InformationGain"
    end
  private
    def fitness(*args)
      ig = Algorithms::InformationGain.calculate(*args).abs
      bns = Algorithms::BiNormalSeperation.calculate(*args).abs
      Math.sqrt(ig * bns)
    end
  end
end
