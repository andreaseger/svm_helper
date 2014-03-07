require "spec_helper"

describe Selector::BiNormalSeperation do
  it_behaves_like 'a selector'

  let(:bns) { Selector::BiNormalSeperation.new(:function) }
  context "#extract_words_from_data" do
    it "should generate a list of words from the data" do
      words = bns.extract_words_from_data(FactoryGirl.build(:data))
      words.should have(10).things
    end
    it "should remove words with 3 characters or less" do
      words = bns.extract_words_from_data(FactoryGirl.build(:data_w_short_words))
      words.should have(6).things
    end
    it "should process multiple sections in the data" do
      words = bns.extract_words_from_data(FactoryGirl.build(:data_w_multiple_sections))
      words.should have(6).things
    end
  end
  context "#generate_global_dictionary" do
    let(:data) { [FactoryGirl.build_list(:data,1),
                  FactoryGirl.build_list(:data_w_short_words,4),
                  FactoryGirl.build_list(:data_w_multiple_sections,3)].flatten }
    let(:words_per_data) { bns.send(:extract_words,data,true) }
    it "should return a list of n words" do
      bns.generate_global_dictionary(words_per_data,2)
      bns.global_dictionary.should have(2).things
    end
    it "should return a list of the n most used words in the data array" do
      bns.generate_global_dictionary(words_per_data,3)
      bns.global_dictionary.should eq(%w(fooo pferd auto))
    end
  end
end