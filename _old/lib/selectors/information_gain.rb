require_relative 'base'
module Selector
  #
  # Feature Selection for Text Classification - HP Labs
  # http://www.google.com/patents/US20040059697
  #
  class InformationGain < Selector::Base
    # nice printable label for this selector
    def label
      "InformationGain"
    end

  private
    def fitness(*args)
      Algorithms::InformationGain.calculate(*args).abs
    end
  end
end
