require "spec_helper"

describe DictionaryBuilder::DocumentFrequency do
  it_behaves_like 'a dictionary builder'

  context "#dictionary" do
    let(:data) do
      #  amet: 12
      # ipsum: 9
      # dolor: 8
      # lorem: 7
      #   sit: 4
      [ FactoryGirl.build_list(:data, 4, data: [%w(lorem ipsum sit),['amet']]),
        FactoryGirl.build_list(:data, 5, data: %w(ipsum dolor amet)),
        FactoryGirl.build_list(:data, 3, data: %w(lorem dolor amet)) ].flatten.shuffle
    end
    before(:each) do
      builder = described_class.new(data, count: 3)
      builder.generate
      @dictionary = builder.dictionary
    end
    it "should return the tokens which appear in the most documents" do
      expect(@dictionary).to include("amet")
      expect(@dictionary).to include("ipsum")
      expect(@dictionary).to include("dolor")
    end
    it "should not include tokens which appear to less often" do
      expect(@dictionary).to_not include("lorem")
      expect(@dictionary).to_not include("sit")
    end
  end
  context "equal dictionary counts" do
    let(:data) do
      # dolor: 6
      #  amet: 5
      #   sit: 5
      # ipsum: 4
      # lorem: 4
      [ FactoryGirl.build_list(:data, 3, data: %w(lorem ipsum dolor sit amet)),
        FactoryGirl.build_list(:data, 2, data: %w(dolor sit amet)),
        FactoryGirl.build_list(:data, 1, data: %w(lorem ipsum dolor)) ].flatten.shuffle
    end
    it "should pick the tokens by alphabetical order" do
      builder = described_class.new(data, count: 2)
      dictionary = builder.dictionary
      expect(dictionary).to include("amet")
      expect(dictionary).to_not include('sit')
    end
    it "should pick the tokens by alphabetical order(2)" do
      builder = described_class.new(data, count: 4)
      dictionary = builder.dictionary
      expect(dictionary).to include("ipsum")
      expect(dictionary).to_not include('lorem')
    end
  end
end