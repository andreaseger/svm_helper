require_relative 'simple'
require 'lingua/stemmer'
module Preprocessor
  #
  # Preprocessor Base Class
  #
  # @author Andreas Eger
  #
  class Stemming < Simple

    def initialize(args={})
      super
      @stemmer = Lingua::Stemmer.new(language: @language)
    end
    def label
      "with_stemming"
    end

    def clean_description desc
      super.map{|w| @stemmer.stem(w) }
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
