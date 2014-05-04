require 'spec_helper'
require 'parallel'

include ParallelHelper
describe ParallelHelper do
  let(:data){ (1..20).to_a }

  context 'parallel enabled' do
    before(:each) do
      @parallel = true
    end
    it 'should work the same as a normal map' do
      p_map(data){ |e| e**2 }.should == data.map{ |e| e**2 }
    end

    it 'should work the same as a normal map with index' do
      p_map_with_index(data){ |e, i| e * i }.should == data.map.with_index{ |e, i| e * i }
    end
  end

  context 'using threads' do
    before(:each) do
      @parallel = :threads
    end
    it 'should work the same as a normal map' do
      p_map(data){ |e| e**2 }.should == data.map{ |e| e**2 }
    end

    it 'should work the same as a normal map with index' do
      p_map_with_index(data){ |e, i| e * i }.should == data.map.with_index{ |e, i| e * i }
    end
  end

  context 'fallback to normal map' do
    before(:each) do
      @parallel = false
    end
    it 'should just call map on data for p_map' do
      expect(data).to receive(:map)
      p_map(data){ |e| e**2 }
    end
    it 'should just call map on data for p_map_with_index' do
      expect(data).to receive(:map).and_return([].map)
      p_map_with_index(data){ |e| e**2 }
    end
  end
end
