require 'spec_helper'

describe Algorithms::InformationGain do
  it_behaves_like 'a algorithm'

  it 'should calculate the correct value' do
    positives = 5
    negatives = 9
    true_positives = 3
    false_positives = 4

    expect(
      described_class.calculate(positives, negatives, true_positives, false_positives)
    ).to be_within(0.001).of(0.8792321)
  end
  context 'entropy' do
    # not ideal to test a private method but I want to make sure it works
    # correctly, but also not expose it
    it 'should calculate the correct entropies' do
      algo = described_class.new(1, 2, 3, 4)
      [
        [5, 9, 0.940],
        [2, 3, 0.971],
        [3, 4, 0.985]
      ].each do |pos, neg, result|
        expect(algo.send(:entropy, pos, neg)).to be_within(0.001).of(result)
      end
    end
  end
  context 'edge cases' do
    it 'should work with zero positives / false_positives' do
      expect(
        described_class.calculate(0, 2, 0, 1)
      ).to be_within(0.001).of(0.0)
    end
    it 'should work with zero negatives / false_negatives' do
      expect(
        described_class.calculate(2, 0, 1, 0)
      ).to be_within(0.001).of(0.0)
    end
  end
end
