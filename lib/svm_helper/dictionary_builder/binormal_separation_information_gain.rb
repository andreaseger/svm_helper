require_relative "base"
module DictionaryBuilder
  #
  # This Builder uses the geometric Mean of Information Gain and Binormal Separation
  #
  # @author Andreas Eger
  #
  class BinormalSeparationInformationGain < Base
    private
    def fitness(*args)
      ig = Algorithms::InformationGain.calculate(*args).abs
      bns = Algorithms::BinormalSeparation.calculate(*args).abs
      Math.sqrt(ig * bns)
    end
  end
end
