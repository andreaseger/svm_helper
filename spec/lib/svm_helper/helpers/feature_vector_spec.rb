require 'spec_helper'

describe FeatureVector do
  let(:data){FactoryGirl.build(:vector)}
  it 'should be a PreprocessedData' do
    expect(data).to be_a(described_class)
  end
  [:classification, :word_data, :data, :correct].each do |attr|
    it "should respond to #{attr}" do
      expect(data).to respond_to(attr)
    end
  end
  it 'should have a correct? method' do
    data.correct = 1
    expect(data.correct?).to be_true

    data.correct = 0
    expect(data.correct?).to be_false
  end
  it 'should properly compare objects on ==' do
    data
    data2 = FactoryGirl.build(:vector, classification: [0, 1, 0, 0])
    expect(data == data).to be_true
    expect(data == data2).to be_false
  end
end
