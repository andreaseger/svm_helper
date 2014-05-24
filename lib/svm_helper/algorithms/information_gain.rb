require_relative 'base'
module SvmHelper
  module Algorithms
    class InformationGain < Base
      # calculates the Information Gain
      # Entropy(X) - Entropy(X|Y)
      def calculate
        entropy(positives, negatives) -
        positive_quota * entropy(true_positives, false_positives) +
        (1 - positive_quota) * entropy(false_negatives, true_negatives)
      end

    private

      def false_negatives
        @false_negatives ||= negatives - false_positives
      end

      def true_negatives
        @true_negatives ||= positives - true_positives
      end

      def total
        @total ||= positives + negatives
      end

      # positive classified / total
      def positive_quota
        @positive_quota ||= (true_positives + false_positives).quo(total)
      end

      # Entropy is a measure of the uncertainty in a random variable
      # https://stackoverflow.com/questions/1859554/what-is-entropy-and-information-gain
      # @param [Float] x positives
      # @param [Float] y negatives
      #
      # @return [Float] entropy
      def entropy x, y
        return 0.0 if x.zero? || y.zero?
        -xlx(x.quo(x + y)) - xlx(y.quo(x + y))
      end

      # calculates x*log2(x)
      # @param [Float] x
      #
      # @return [Float] x*log2(x)
      def xlx x
        x * Math.log2(x)
      end
    end
  end
end
