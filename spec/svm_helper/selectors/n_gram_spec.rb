require "spec_helper"

describe Selector::NGram do
  it_behaves_like 'a selector'

  let(:ngram) { Selector::NGram.new(:function, gram_size: 3) }
  context "#extract_words_from_data" do
    it "should generate a list of words from the data" do
      words = ngram.extract_words_from_data(FactoryGirl.build(:data))
      words.should have(4).things
    end
    it "should remove words with 3 characters or less" do
      words = ngram.extract_words_from_data(FactoryGirl.build(:data_w_short_words))
      words.should have(2).things
    end
    it "should process multiple sections in the data" do
      words = ngram.extract_words_from_data(FactoryGirl.build(:data_w_multiple_sections))
      words.should have(2).things
    end
  end
end