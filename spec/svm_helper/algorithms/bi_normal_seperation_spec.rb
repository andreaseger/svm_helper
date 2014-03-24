require 'spec_helper'

describe Algorithms::BiNormalSeperation do
  it_behaves_like 'a algorithm'
  # not ideal to test private methods but I want to make sure it works
  # correctly, but also not expose them
  context "calclate" do
    it "uses the inverse_cumulative_distribution_function twice" do
      described_class.any_instance.should_receive(:inverse_cumulative_distribution_function).twice.and_return(2)
      described_class.calculate(1,2,3,4)
    end
  end
  context "cdf & inverse_cdf" do
    let(:algo) { described_class.new(1,2,3,4) } #params not important
    [
      [0.5, 0.691462],
      [0.3, 0.617911],
      [0.8, 0.788145],
      [2.0, 0.97725],
      [-1.5, 0.0668072]
    ].each do |a,b|
      it "should calculate the correct cdf for #{a}" do
        expect(
          algo.send(:cumulative_distribution_function, a)
        ).to be_within(0.0001).of(b)
      end
      it "should calculate the correct inverse cdf for #{b}" do
        expect(
          algo.send(:inverse_cumulative_distribution_function, b)
        ).to be_within(0.0001).of(a)
      end
    end
    # just to make sure the inverse cdf works reliable enough
    it "inverse_cdf(cdf(value)) =~ value" do
      100.times do
        value = rand(-2.0..2.0)
        expect(
          algo.send(:inverse_cumulative_distribution_function,
            algo.send(:cumulative_distribution_function, value) )
        ).to be_within(0.001).of(value)
      end
    end
  end
end
