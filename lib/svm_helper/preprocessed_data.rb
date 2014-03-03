class PreprocessedData
  attr_accessor :data, :id, :label

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  # comperator
  # @param [PreprocessedData] another
  def == another
    [:data, :id, :label].map { |e| self.send(sym) == another.send(sym)}.all?
  end
end
