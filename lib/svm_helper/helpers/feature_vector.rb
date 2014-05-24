module SvmHelper
  #
  # Holds encoded features after feature selection given a dictionary
  #
  # @author Andreas Eger
  #
  class FeatureVector
    ATTRS = [:word_data, :classification, :classification_array, :correct]
    attr_accessor(*ATTRS)

    def initialize params={}
      params.each do |key, value|
        send("#{key}=", value)
      end
    end

    # wrapper for correct attribute which converts it to a boolean
    def correct?
      correct != 0
    end

    # word + encoded classification data
    def data
      if classification_array && !classification_array.empty?
        word_data + classification_array
      else
        word_data
      end
    end

    # comperator
    # @param [FeatureVector] other
    def == other
      return false if self.class != other.class
      ATTRS.map{ |e| send(e) == other.send(e) }.all?
    end
  end
end
