require_relative "base"
module DictionaryBuilder
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  # @author Andreas Eger
  #
  class BiNormalSeperation < Base
    private
    def fitness(*args)
      Algorithms::BiNormalSeperation.calculate(*args).abs
    end
  end
end