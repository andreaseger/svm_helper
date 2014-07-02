require 'spec_helper'

describe Selector do
  let(:dictionary){ Dictionary.new(%w(auto garten hase haus pferd)) }
  let(:selector){ Selector.new(dictionary) }
  let(:data){ FactoryGirl.build(:data) } # haus fooo garten baaz pferd fooo

  it "should set 0's and 1's for each word in the dictionary" do
    feature_vector = selector.generate(data)
    expect(feature_vector.data.first(5)).to eq([0,1,0,1,1])
  end
  it "should set 0's and 1's for each word in the dictionary" do
    feature_vector = selector.generate([data]).first
    expect(feature_vector.data.first(5)).to eq([0,1,0,1,1])
  end

end
