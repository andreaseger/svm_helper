require_relative 'base'
module DictionaryBuilder
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  # @author Andreas Eger
  #
  class InformationGain < Base
  private

    def fitness *args
      Algorithms::InformationGain.calculate(*args).abs
    end
  end
end
