require 'spec_helper'

describe PreprocessedData do
  let(:data){FactoryGirl.build(:data)}
  it 'should be a PreprocessedData' do
    expect(data).to be_a(described_class)
  end
  [:id, :data, :correct].each do |attr|
    it "should respond to #{attr}" do
      expect(data).to respond_to(attr)
    end
  end
  it 'should properly compare objects on ==' do
    data
    data2 = FactoryGirl.build(:data, id: 45)
    expect(data == data).to be_true
    expect(data == data2).to be_false
  end
end
