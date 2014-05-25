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

      def clean_text text
        super.map{ |w| @stemmer.stem(w) }
      end
    end
  end
end
