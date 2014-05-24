module SvmHelper
  #
  # Wrapper for stripped text data
  #
  # @author Andreas Eger
  #
  class PreprocessedData
    ATTRS = [:data, :id, :correct]
    attr_accessor(*ATTRS)

    def initialize params={}
      params.each do |key, value|
        send("#{key}=", value)
      end
    end

    # comperator
    # @param [PreprocessedData] other
    def == other
      return false if self.class != other.class
      ATTRS.all?{ |e| send(e) == other.send(e) }
    end
  end
end
