require_relative 'interface_helper'
#
# FeatureVector interface
#
# @author Andreas Eger
class FeatureVector < InterfaceHelper
  attribute :word_data
  attribute :classification_arrays
  attribute :labels

  def label
    labels[classification]
  end
  def data
    word_data + classification_arrays[classification]
  end
end