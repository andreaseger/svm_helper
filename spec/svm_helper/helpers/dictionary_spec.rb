require 'spec_helper'

describe Dictionary do
  it "should act as Array" do
    expect(Dictionary.new).to be_a(Array)
  end
end