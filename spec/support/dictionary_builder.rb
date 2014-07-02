shared_examples_for 'a dictionary builder' do
  let(:data) do
    #  amet: 12
    # ipsum: 9
    # dolor: 8
    # lorem: 7
    #   sit: 4
    [FactoryGirl.build_list(:data, 4, token: [%w(lorem ipsum sit), ['amet']], correct: true),
     FactoryGirl.build_list(:data, 5, token: %w(ipsum dolor amet), correct: true),
     FactoryGirl.build_list(:data, 3, token: %w(lorem dolor amet), correct: false)].flatten.shuffle
  end
  context '#size' do
    1.upto(3) do |n|
      it "should return the correct number of features (#{n})" do
        builder = described_class.new(data, count: n)
        dictionary = builder.dictionary
        expect(dictionary.size).to eq(n)
      end
    end
  end

  context '#generate' do
    let(:builder){ described_class.new(data, count: 4) }
    it 'should set dictionary' do
      builder.generate
      expect(builder.dictionary).to_not be_nil
    end
  end

  context '#dictionary' do
    let(:builder){ described_class.new(data, count: 4) }
    it 'should return a Dictionary' do
      expect(builder.dictionary).to be_a(Dictionary)
    end
    it 'should call build_dictionary automatically' do
      expect(builder).to receive(:build_dictionary)
      builder.dictionary
    end
  end
end
