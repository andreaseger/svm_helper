# encoding: UTF-8
module Preprocessor
  #
  # Base Class for Preprocessors
  #
  # @author Andreas Eger
  #
  class Base
    include ::ParallelHelper
    def initialize(args={})
      @parallel = args.fetch(:parallel){false}
    end

    def label
      self.class.to_s
    end
  end
end
