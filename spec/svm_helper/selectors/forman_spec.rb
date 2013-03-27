require "spec_helper"

describe Selector::Forman do
  it_behaves_like 'a selector'

  let(:forman) { Selector::Forman.new(:function) }
  context "#extract_words_from_data" do
    it "should generate a list of words from the data" do
      words = forman.extract_words_from_data(FactoryGirl.build(:data))
      words.should have(11).things
    end
    it "should remove words with 3 characters or less" do
      words = forman.extract_words_from_data(FactoryGirl.build(:data_w_short_words))
      words.should have(7).things
    end
    it "should process multiple sections in the data" do
      words = forman.extract_words_from_data(FactoryGirl.build(:data_w_multiple_sections))
      words.should have(7).things
    end
  end
  context "#generate_global_dictionary" do
    let(:data) { [FactoryGirl.build_list(:data,1),
                  FactoryGirl.build_list(:data_w_short_words,2),
                  FactoryGirl.build_list(:data_w_multiple_sections,3)].flatten }
    let(:words_per_data) { forman.extract_words(data,true) }
    it "should return a list of n words" do
      forman.generate_global_dictionary(words_per_data,2)
      forman.global_dictionary.should have(2).things
    end
    it "should return a list of the n most used words in the data array" do
      forman.generate_global_dictionary(words_per_data,3)
      forman.global_dictionary.should eq(%w(fooo auto pferd))
    end
  end
end