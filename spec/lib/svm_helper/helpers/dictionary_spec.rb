require 'spec_helper'

describe Dictionary do
  it 'should be a SortedSet' do
    expect(Dictionary.new).to be_a(SortedSet)
  end
end
