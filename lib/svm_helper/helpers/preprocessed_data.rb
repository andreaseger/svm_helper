#
# Wrapper for stripped text data
#
# @author Andreas Eger
#
class PreprocessedData
  ATTRS = [:data, :id, :correct]
  attr_accessor *ATTRS

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  # comperator
  # @param [PreprocessedData] another
  def ==(another)
    return false if self.class != another.class
    ATTRS.all?{|e| send(e) == another.send(e)}
  end
end
