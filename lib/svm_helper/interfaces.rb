#
# @abstract Subclass and define attributes
#
# @author Andreas Eger
class InterfaceHelper
  @@_attributes = Hash.new { |hash, key| hash[key] = [] }

  #
  # creates setter/getter similar to attr_accesor
  # @param  name [Symbol]
  # @macro [attach] attribute
  #   @method $1
  #     reads $1
  #   @method $1=
  #     saves $1
  def self.attribute name
    define_method(name) do
      @_attributes[name]
    end
    define_method(:"#{name}=") do |v|
      @_attributes[name] = v
    end
    attributes << name unless attributes.include? name
  end
  def self.attributes
    @@_attributes[self]
  end
  def initialize(params={})
    @_attributes = {}
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  #
  # custom comperator
  # @param anOther [InterfaceHelper]
  #
  # @return [Boolean] result after comparing each attribute
  def == anOther
    @_attributes.keys.map{ |sym| self.send(sym) == anOther.send(sym)}.reduce(true){|a,e| a && e }
  end
end

#
# FeatureVector interface
#
# @author Andreas Eger
class FeatureVector < InterfaceHelper
  attribute :data
  attribute :label
end

#
# PreprocessedData interface
#
# @author Andreas Eger
class PreprocessedData < InterfaceHelper
  attribute :data
  attribute :industry_id
  attribute :function_id
  attribute :career_level_id
  attribute :label
end