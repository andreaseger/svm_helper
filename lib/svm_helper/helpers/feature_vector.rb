class FeatureVector
  ATTRS = [:word_data, :classification, :classification_array, :correct]
  attr_accessor *ATTRS

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def correct?
    correct != 0
  end

  def data
    word_data + classification_array
  end

  # comperator
  # @param [FeatureVector] another
  def == another
    return false if self.class != another.class
    ATTRS.map { |e| self.send(e) == another.send(e) }.all?
  end

end