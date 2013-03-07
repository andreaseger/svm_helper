require 'spec_helper'

describe Preprocessor::WithIndustryMap do
  it_behaves_like 'a preprocessor'
  let(:preprocessor) { Preprocessor::WithIndustryMap.new(industry_map: {1423=>3, 523=>54}) }
  let(:job) { FactoryGirl.build(:job) }
  let(:jobs) { [job] }
  before(:each) do
    job.stubs(:classification_id)
    job.stubs(:label)
  end
  it "should make use of a industry_map" do
    preprocessor.expects(:map_industry_id)
    preprocessor.process(jobs)
  end
end