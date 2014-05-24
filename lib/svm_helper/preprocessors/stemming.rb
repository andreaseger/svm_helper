require_relative 'simple'
require_relative '../helpers/stemmer'
module SvmHelper
  module Preprocessor
    #
    # Preprocessor Base Class
    #
    # @author Andreas Eger
    #
    class Stemming < Simple
      def initialize args={}
        super
        @stemmer = ::Stemmer.new(language: @language)
      end

      def clean_description desc
        super.map{ |w| @stemmer.stem(w) }
      end

    private

      def process_job job
        PreprocessedData.new(
          token: [clean_title(job[:title]), clean_description(job[:description])],
          id: job[:id],
          correct: job[:label]
        )
      end
    end
  end
end
