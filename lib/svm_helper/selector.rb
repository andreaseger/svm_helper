module SvmHelper
  class Selector
    include ParallelHelper
    attr_accessor :dictionary
    def initialize dictionary
      @dictionary = dictionary
    end

    #
    # generates a list of feature vetors and their labels from preprocessed data
    # @param  data_set [Array<PreprocessedData>] list of preprocessed data
    #
    # @return [Array<FeatureVector>] list of feature vectors and labels
    def generate data_set
      if data_set.is_a? Array
        p_map(data_set){ |data| make_vector data }
      else
        make_vector data_set
      end
    end

  private

    #
    # creates a feature vector for the given words, classification and dictionary
    # also adds the label
    # @param  data [PreprocessedData]
    #
    # @return [FeatureVector]
    def make_vector data
      FeatureVector.new(
        text_features: dictionary.map do |dic_word|
                         data.token.include?(dic_word) ? 1 : 0
                       end,
        classification: data.id,
        correct: data.correct ? 1 : 0
      )
    end
  end
end
