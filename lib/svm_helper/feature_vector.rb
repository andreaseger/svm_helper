require_relative 'interface_helper'
#
# FeatureVector interface
#
# @author Andreas Eger
class FeatureVector < InterfaceHelper
  attribute :word_data
  attribute :classification
  attribute :label

  def data
    word_data + classification
  end
end