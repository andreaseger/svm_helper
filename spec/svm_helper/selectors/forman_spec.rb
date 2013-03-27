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
end