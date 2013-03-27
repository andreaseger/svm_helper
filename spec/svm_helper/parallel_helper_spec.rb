require 'spec_helper'
require 'parallel'

include ParallelHelper
describe ParallelHelper do
  let(:data) { (1..20).to_a }
  context "parallel map" do
    it "should return as a normal map" do
      p_map(data){|e| e**2 }.should == data.map{|e| e**2 }
    end
  end
  context "parallel map with index" do
    it "should return as a normal map with index" do
      p_map_with_index(data){|e,i| e*i }.should == data.map.with_index{|e,i| e*i }
    end
  end
end