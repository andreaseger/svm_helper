require 'spec_helper'

describe DictionaryBuilder::InformationGain do
  it_behaves_like 'a dictionary builder'
  context '#dictionary' do
    let(:data) do
      # ipsum, 1.3931558784658322
      # dolor, 1.2169171866886992
      # et, 1.2169171866886992
      # labore, 1.0487949406953985
      # sit, 0.8600730651545314
      # amet, 0.6919508191612307
      # ut, 0.6919508191612307
      # incididunt, 0.5157121273840978
      # consectetur, 0.20443400292496494
      # tempor, 0.19920350542916276
      # adipisicing, 0.09235938389499487
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
      %w(ipsum dolor et labore sit).each do |word|
        expect(@dictionary).to include(word)
      end
    end
    it 'should not include tokens with lower score' do
      %w(amet ut incididunt consectetur tempor adipisicing do eiusmod elit sed).each do |word|
        expect(@dictionary).to_not include(word)
      end
    end
  end
end
