require 'spec_helper'

# just some very basic test to make sure these functions do not fail
describe "Calc" do
  include Selector::IG
  include Selector::BNS
  let(:test_data){ [
    [34, 23, 28, 17],
    [31, 17, 23, 12],
    [44, 39, 41, 36],
    [44, 23, 41, 23],
    [44, 39, 0, 36],
    [44, 39, 41, 0],
    [62, 81, 15, 73]
  ]}

  context Selector::IG do
    it "should not fail" do
      test_data.each do |data|
        ->{information_gain(*data)}.should_not raise_error
      end
    end
    it "should return some values" do
      test_data.each do |data|
        information_gain(*data).should be_a(Numeric)
      end
    end
  end

  context Selector::BNS do
    it "should not fail" do
      test_data.each do |data|
        ->{bi_normal_seperation(*data)}.should_not raise_error
      end
    end
    it "should return some values" do
      test_data.each do |data|
        bi_normal_seperation(*data).should be_a(Numeric)
      end
    end
  end
end