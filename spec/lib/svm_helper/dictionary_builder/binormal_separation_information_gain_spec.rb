require 'spec_helper'

describe DictionaryBuilder::BinormalSeparationInformationGain do
  it_behaves_like 'a dictionary builder'
  context '#dictionary' do
    let(:data) do
      # labore, 0.8470264295340086
      # sit, 0.767042350912129
      # ipsum, 0.7565971847453518
      # dolor, 0.46460414256106275
      # et, 0.46460414256106275
      # incididunt, 0.460329213688909
      # amet, 0.35034036598093393
      # ut, 0.35034036598093393
      # tempor, 0.29292044637356957
      # adipisicing, 0.2788039070847824
      # consectetur, 0.2275802329366404
      # do, 0.0
      # eiusmod, 0.0
      # elit, 0.0
      # sed, 0.0
      # rubocop:disable LineLength
      [FactoryGirl.build(:data, data: %w(lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod), correct: true),
       FactoryGirl.build(:data, data: %w(ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor), correct: false),
       FactoryGirl.build(:data, data: %w(dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt), correct: false),
       FactoryGirl.build(:data, data: %w(sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut), correct: true),
       FactoryGirl.build(:data, data: %w(amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore), correct: false),
       FactoryGirl.build(:data, data: %w(consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et), correct: true),
       FactoryGirl.build(:data, data: %w(adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore), correct: false),
       FactoryGirl.build(:data, data: %w(elit sed do eiusmod tempor incididunt ut labore et dolore magna), correct: false)].flatten.shuffle
      # rubocop:enable LineLength
    end
    before(:each) do
      builder = described_class.new(data, count: 5)
      @dictionary = builder.dictionary
    end
    it 'should return the tokens with the highest scores' do
      %w(labore sit ipsum dolor et).each do |word|
        expect(@dictionary).to include(word)
      end
    end
    it 'should not include tokens with lower score' do
      %w(incididunt amet ut tempor adipisicing consectetur do eiusmod elit sed).each do |word|
        expect(@dictionary).to_not include(word)
      end
    end
  end
end
