require "spec_helper"

class TestSelector < Selector::Base
end

describe TestSelector do
  it_behaves_like 'a selector'
  let(:subject) { described_class.new(:function) }

  context "#extract_words" do
    it "should call extract_words_from_data for each data object" do
      subject.expects(:extract_words_from_data).times(4)
      subject.extract_words(FactoryGirl.build_list(:data,4))
    end
    it "should return an array of word arrays" do
      words_per_data = subject.extract_words(FactoryGirl.build_list(:data,4))
      words_per_data.each do |words|
        expect(words).to eq(subject.extract_words_from_data(FactoryGirl.build(:data)))
      end
    end
  end
  context "#extract_words_from_data" do
    it "should generate a list of words from the data" do
      words = subject.extract_words_from_data(FactoryGirl.build(:data))
      words.should have(6).things
    end
    it "should remove words with 3 characters or less" do
      words = subject.extract_words_from_data(FactoryGirl.build(:data_w_short_words))
      words.should have(4).things
    end
    it "should process multiple sections in the data" do
      words = subject.extract_words_from_data(FactoryGirl.build(:data_w_multiple_sections))
      words.should have(4).things
    end
  end
end
