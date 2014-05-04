module Algorithms
  class Base
    attr_accessor :positives, :negatives, :true_positives, :false_positives

    def initialize pos, neg, tp, fp
      self.positives = pos
      self.negatives = neg
      self.true_positives = tp
      self.false_positives = fp
    end
    def self.calculate pos, neg, tp, fp
      new(pos, neg, tp, fp).calculate
    end
  end
end
