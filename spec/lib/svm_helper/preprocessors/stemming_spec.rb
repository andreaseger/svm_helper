require 'spec_helper'

describe Preprocessor::Stemming do
  it_behaves_like 'a preprocessor'
  let(:preprocessor){Preprocessor::Stemming.new}
  let(:job){FactoryGirl.build(:job)}
  let(:jobs){[job]}
  it 'should have a label' do
    expect(preprocessor.label).to eq('SvmHelper::Preprocessor::Stemming')
  end
  it 'should reduce words to their stem' do
    preprocessor.clean_text('developer engineering').should == %w(develop engin)
  end
end
