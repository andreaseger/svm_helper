require 'spec_helper'

describe Preprocessor::Simple do
  let(:preprocessor) { Preprocessor::Simple.new(ip_map: {1423=>3, 523=>54}) }
  let(:job) { FactoryGirl.build(:job) }
  let(:jobs) { [job] }
  it "should make use of a industry_map" do
    preprocessor.expects(:map_id)
    preprocessor.process(jobs)
  end
end