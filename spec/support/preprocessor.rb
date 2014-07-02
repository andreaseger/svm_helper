shared_examples_for 'a preprocessor' do
  let(:preprocessor){ described_class.new(1423 => 3, 523 => 54) }
  let(:job){ FactoryGirl.build(:entry) }
  let(:jobs){ [job] }

  it{ expect(preprocessor).to respond_to :process }
  it 'should return a PreprocessedData object' do
    expect(preprocessor.process(job)).to be_a(PreprocessedData)
  end
  it 'should be able to process multiple jobs' do
    preprocessor.process(jobs).each do |e|
      expect(e).to be_a(PreprocessedData)
    end
  end
end
