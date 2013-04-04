require 'spec_helper'

describe Preprocessor::IDMapping do
  it_behaves_like 'a preprocessor'
  let(:preprocessor) { Preprocessor::IDMapping.new(1423=>3, 523=>54) }
  let(:job) { FactoryGirl.build(:job) }
  let(:jobs) { [job] }
  it "should make use of a industry_map" do
    preprocessor.expects(:map_id)
    preprocessor.process(jobs)
  end
end