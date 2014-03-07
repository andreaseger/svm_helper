shared_examples_for 'a algorithm' do
  let(:test_data){ [
    [34, 23, 28, 17],
    [31, 17, 23, 12],
    [44, 39, 41, 36],
    [44, 23, 41, 23],
    [44, 39, 0, 36],
    [44, 39, 41, 0],
    [62, 81, 15, 73]
  ]}

  it "should not fail" do
    test_data.each do |data|
      expect{
        described_class.new(*data).calculate
      }.to_not raise_error
    end
  end
  it "should return some values" do
    test_data.each do |data|
      expect(described_class.new(*data).calculate).to be_a(Numeric)
    end
  end
end
