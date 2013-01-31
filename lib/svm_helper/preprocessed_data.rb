require_relative 'interface_helper'
#
# PreprocessedData interface
#
# @author Andreas Eger
class PreprocessedData < InterfaceHelper
  attribute :data
  attribute :ids
  attribute :labels

  def id
    ids[classification]
  end
  def label
    labels[classification]
  end
end