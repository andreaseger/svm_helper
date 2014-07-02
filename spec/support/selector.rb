shared_examples_for 'a selector' do
  let(:selector){ described_class.new(:function) }
  let(:data){ FactoryGirl.build(:data) }

  it 'should return a FeatureVector object' do
    expect(selector.generate_vector(data)).to be_a(FeatureVector)
  end
  it "should create and array with 0 and 1's" do
    vector = selector.generate_vector(data)
    vector.data.each do |e|
      expect([0, 1]).to include(e)
    end
  end
  it 'should respond to generate_vectors' do
    expect(selector).to respond_to(:generate_vectors)
  end
end
