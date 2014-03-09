class FeatureVector
  ATTRS = [:word_data, :classification, :correct]
  attr_accessor *ATTRS

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def data
    word_data + classification
  end

  # comperator
  # @param [FeatureVector] another
  def == another
    return false if self.class != another.class
    ATTRS.map { |e| self.send(e) == another.send(e) }.all?
  end
end