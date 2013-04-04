require_relative 'simple'
require 'fast_stemmer'
module Preprocessor
  #
  # Preprocessor Base Class
  #
  # @author Andreas Eger
  #
  class Stemming < Simple

    def label
      "with_stemming"
    end

    def clean_description desc
      super.map(&:stem)
    end
    private
    def process_job job
      PreprocessedData.new(
        data: [clean_title(job[:title]), clean_description(job[:description])],
        id: job[:id],
        label: job[:label]
      )
    end
  end
end