require 'spec_helper'

shared_examples_for 'a preprocessor' do
  let(:preprocessor) { described_class.new(industry_map: {1423=>3, 523=>54}) }
  let(:job) { FactoryGirl.build(:job) }
  let(:jobs) { [job] }

  before(:each) do
    job.stubs(:classification_id)
    job.stubs(:label)
  end
  it { preprocessor.should respond_to :process }
  it "should return a PreprocessedData object" do
    preprocessor.process(job).should be_a(PreprocessedData)
  end
  it "should be able to process multiple jobs" do
    preprocessor.process(jobs).each do |e|
      e.should be_a(PreprocessedData)
    end
  end

  it "should make use of a industry_map" do
    preprocessor.expects(:map_industry_id)
    preprocessor.process(jobs)
  end
end
