class FeatureVector
  attr_accessor :word_data, :classification, :label

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def data
    word_data + classification
  end

  def == another
    [:word_data, :classification, :label].map { |e| self.send(sym) == another.send(sym) }.all?
  end
end