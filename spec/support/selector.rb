shared_examples_for 'a selector' do
  let(:selector) { described_class.new(:function) }
  let(:data) { FactoryGirl.build(:data) }

  it "should return a FeatureVector object" do
    selector.generate_vector(data).should be_a(FeatureVector)
  end
  it "should create and array with 0 and 1's" do
    vector = selector.generate_vector(data)
    vector.data.each do |e|
      [0,1].should include(e)
    end
  end
  it "should respond to generate_vectors" do
    selector.should respond_to(:generate_vectors)
  end
end
