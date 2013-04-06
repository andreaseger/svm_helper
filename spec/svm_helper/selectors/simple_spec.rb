require "spec_helper"

describe Selector::Simple do
  it_behaves_like 'a selector'

  let(:simple) { Selector::Simple.new(:function) }
  it "should have select_feature_vector implemented" do
    expect { simple.generate_vectors([]) }.to_not raise_error
  end
  context "#extract_words_from_data" do
    it "should generate a list of words from the data" do
      words = simple.extract_words_from_data(FactoryGirl.build(:data))
      words.should have(6).things
    end
    it "should remove words with 3 characters or less" do
      words = simple.extract_words_from_data(FactoryGirl.build(:data_w_short_words))
      words.should have(4).things
    end
    it "should process multiple sections in the data" do
      words = simple.extract_words_from_data(FactoryGirl.build(:data_w_multiple_sections))
      words.should have(4).things
    end
  end
  context "#extract_words" do
    it "should call extract_words_from_data for each data object" do
      simple.expects(:extract_words_from_data).times(4)
      simple.extract_words(FactoryGirl.build_list(:data,4))
    end
    it "should return an array of word arrays" do
      words_per_data = simple.extract_words(FactoryGirl.build_list(:data,4))
      words_per_data.each do |words|
        words.should eq(simple.extract_words_from_data(FactoryGirl.build(:data)))
      end
    end
  end
  context "#generate_global_dictionary" do
    let(:data) { [FactoryGirl.build_list(:data,1),
                  FactoryGirl.build_list(:data_w_short_words,2),
                  FactoryGirl.build_list(:data_w_multiple_sections,3)].flatten }
    let(:words_per_data) { simple.extract_words(data) }
    it "should return a list of n words" do
      simple.generate_global_dictionary(words_per_data,2)
      simple.global_dictionary.should have(2).things
    end
    it "should return a list of the n most used words in the data array" do
      simple.generate_global_dictionary(words_per_data,3)
      simple.global_dictionary.should eq(%w(fooo auto baaz))
    end
  end
  context "#build_dictionary" do
    let(:data) { [FactoryGirl.build_list(:data,1),
                  FactoryGirl.build_list(:data_w_short_words,2),
                  FactoryGirl.build_list(:data_w_multiple_sections,3)].flatten }
    it "should return a list of n words" do
      simple.build_dictionary(data,2)
      simple.global_dictionary.should have(2).things
    end
    it "should return a list of the n most used words in the data array" do
      simple.build_dictionary(data,3)
      simple.global_dictionary.should eq(%w(fooo auto baaz))
    end
  end
  context "#generate_vector" do
    let(:dictionary) { %w(auto pferd haus hase garten) }
    let(:data) { FactoryGirl.build(:data) }
    let(:simple) { Selector::Simple.new(:career_level) }
    let(:vector) { simple.generate_vector(data) }

    before(:each) do
      simple.stubs(:global_dictionary).returns(dictionary)
    end
    it "should build a feature vector for each dataset with the size of the dictionary plus classifications" do
      vector.data.should have(5+8).things
    end
    it "should set 0 if a word from the dictionary NOT exists at the corresponding index" do
      vector.data[0].should eq(0)
    end
    it "should set 1 if a word from the dictionary exists at the corresponding index" do
      vector.data[1].should eq(1)
    end
    it "should set 0's and 1's for each word in the dictionary" do
      vector.data.first(5).should eq([0,1,1,0,1])
    end
    it "should add a n-sized array of 0's and 1's to the results" do
      vector.data.last(8).should eq([0,0,0,0,0,0,1,0])
    end
    it "should call make_vector" do
      simple.expects(:make_vector).once
      simple.generate_vector(data)
    end
    context "custom dictionary" do
      it "should accept a custom dictionary" do
        vector = simple.generate_vector(data, %w(pferd flasche glas))
        vector.data.should eq([[1,0,0],[0,0,0,0,0,0,1,0]].flatten)
      end
    end
  end
  context "#generate_vectors" do
    let(:dictionary) { %w(auto pferd haus hase garten) }
    let(:data) { FactoryGirl.build_list(:data,2) }
    let(:words_per_data) { [%w(pferd hase flasche),%w(flasche glas hase meer)] }
    before(:each) do
      simple.stubs(:global_dictionary).returns(dictionary)
    end
    it "should call extract words" do
      simple.expects(:extract_words).returns([])
      simple.generate_vectors(data)
    end
    it "should call generate_global_dictionary" do
      simple.stubs(:extract_words).returns([])
      simple.expects(:generate_global_dictionary).returns([])
      simple.generate_vectors(data)
    end
    it "should call make_vector for each set of words" do
      simple.stubs(:extract_words).returns(words_per_data)
      simple.expects(:make_vector).twice
      simple.generate_vectors(data)
    end
    context "parallel" do
      let(:parallel) { Selector::Simple.new(:function, parallel: true) }
      before(:each) do
        require 'parallel'
        simple.stubs(:global_dictionary).returns(dictionary)
        parallel.stubs(:global_dictionary).returns(dictionary)
      end
      it "should be equal results in processes" do
        single = simple.generate_vectors(data)
        p_data = parallel.generate_vectors(data)
        single.each.with_index {|e,i| e.data.should == p_data[i].data}
      end
    end
  end
end
