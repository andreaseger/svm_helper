require_relative "base"
module DictionaryBuilder
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  # @author Andreas Eger
  #
  class BiNormalSeparation < Base
    private
    def fitness(*args)
      Algorithms::BinormalSeparation.calculate(*args).abs
    end
  end
end