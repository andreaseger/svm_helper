require "spec_helper"

describe DictionaryBuilder::BiNormalSeperation do
  it_behaves_like 'a dictionary builder'
  context "#dictionary" do
    let(:data) do
      # adipisicing, 0.8416212335729147
      # labore, 0.6840744024312575
      # sit, 0.6840744024312571
      # tempor, 0.4307272992954573
      # incididunt, 0.41089393427745746
      # ipsum, 0.41089393427745663
      # consectetur, 0.2533471031357999
      # dolor, 0.17738019615965778
      # et, 0.17738019615965778
      # amet, 0.1773801961596574
      # ut, 0.1773801961596574
      # do, 0.0
      # eiusmod, 0.0
      # elit, 0.0
      # sed, 0.0
      [ FactoryGirl.build(:data, data: %w(lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod), correct: true),
        FactoryGirl.build(:data, data: %w(ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor), correct: false),
        FactoryGirl.build(:data, data: %w(dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt), correct: false),
        FactoryGirl.build(:data, data: %w(sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut), correct: true),
        FactoryGirl.build(:data, data: %w(amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore), correct: false),
        FactoryGirl.build(:data, data: %w(consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et), correct: true),
        FactoryGirl.build(:data, data: %w(adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore), correct: false),
        FactoryGirl.build(:data, data: %w(elit sed do eiusmod tempor incididunt ut labore et dolore magna), correct: false)].flatten.shuffle
    end
    before(:each) do
      builder = described_class.new(data, count: 5)
      @dictionary = builder.dictionary
    end
    it "should return the tokens with the highest scores" do
      %w(adipisicing labore sit tempor incididunt).each do |word|
        expect(@dictionary).to include(word)
      end
    end
    it "should not include tokens with lower score" do
      %w(ipsum consectetur dolor et amet ut do eiusmod elit sed).each do |word|
        expect(@dictionary).to_not include(word)
      end
    end
  end
end
