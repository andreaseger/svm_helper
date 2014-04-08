require "spec_helper"

describe "binary encoded classification" do
  let(:simple) { Selector::Simple.new(:career_level, classification_encoding: :binary) }

  let(:dictionary) { %w(auto pferd haus hase garten) }
  let(:data) { FactoryGirl.build(:data) }
  let(:vector) { simple.generate_vector(data) }

  before(:each) do
    simple.stub(:global_dictionary).and_return(dictionary)
  end
  it "should build a feature vector for each dataset with the size of the dictionary plus classifications" do
    vector.data.should have(5+4).things
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
    vector.data.last(4).should eq([0,1,1,1])
  end
  it "should call make_vector" do
    expect(simple).to receive(:make_vector).once
    simple.generate_vector(data)
  end
  context "custom dictionary" do
    it "should accept a custom dictionary" do
      vector = simple.generate_vector(data, %w(pferd flasche glas))
      vector.data.should eq([[1,0,0],[0,1,1,1]].flatten)
    end
  end
end