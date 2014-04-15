shared_examples_for 'a preprocessor' do
  let(:preprocessor){described_class.new(1423 => 3, 523 => 54)}
  let(:job){FactoryGirl.build(:job)}
  let(:jobs){[job]}

  it{preprocessor.should respond_to :process}
  it 'should return a PreprocessedData object' do
    preprocessor.process(job).should be_a(PreprocessedData)
  end
  it 'should be able to process multiple jobs' do
    preprocessor.process(jobs).each do |e|
      e.should be_a(PreprocessedData)
    end
  end
end
