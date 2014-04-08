require 'spec_helper'

describe Tokenizer do
  let(:tokenizer) { described_class.new }
  it "should return an array" do
    token = tokenizer.do("lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod")
    expect(token).to be_a(Array)
  end
  it "should split strings into words" do
    token = tokenizer.do("lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod")
    expect(token).to eql(%w(lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod))
  end
  it "should correctly split Array of strings" do
    token = tokenizer.do(["tempor incididunt ut labore et dolore","magna aliqua ut enim ad minim veniam"])
    expect(token).to eql(%w(tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam))
  end
  # it "should correctly split Array of strings directly via multiple params" do
  #   token = tokenizer.do("tempor incididunt ut labore et dolore","magna aliqua ut enim ad minim veniam")
  #   expect(token).to eql(%w(tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam))
  # end
  it "should split on punctuation .,:;'/!?-(" do
    token = tokenizer.do("quis.nostrud,exercitation:ullamco;laboris'nisi/ut!aliquip?ex-ea(commodo")
    expect(token).to eql(%w(quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo))
  end
  it 'should split on punctuation "){}[]\\<>@' do
    token = tokenizer.do('consequat"duis)aute{irure}dolor[in]reprehenderit\in<voluptate>velit@esse')
    expect(token).to eql(%w(consequat duis aute irure dolor in reprehenderit in voluptate velit esse))
  end
  it "should be fine with multiple symbols" do
    token = tokenizer.do('cillum dolore, eu      fugiat nulla pariatur. excepteur ,sint.... occaecat [cupidatat] non')
    expect(token).to eql(%w(cillum dolore eu fugiat nulla pariatur. excepteur sint occaecat cupidatat non))
  end
  context "grams" do
    it "should be able to make two grams" do
      token = tokenizer.do('proident sunt in culpa qui officia deserunt mollit anim id est laborum', gram: 2)
      expect(token).to eql(["proident sunt", "in culpa", "qui officia", "deserunt mollit", "anim id", "est laborum"])
    end
    it "should remove punctuation and unnecessary whitespace within grams" do
      token = tokenizer.do('cillum dolore, eu      fugiat nulla pariatur. excepteur ,sint.... occaecat [cupidatat] non', gram: 2)
      expect(token).to eql(['cillum dolore', 'eu fugiat', 'nulla pariatur', 'excepteur sint', 'occaecat cupidatat', 'non'))
    end
    3.upto(5) { |n|
      it "can handle #{n}-grams" do
        txt = 'proident sunt in culpa qui officia deserunt mollit anim id est laborum'
        token = tokenizer.do(txt, gram: n)
        expect(token).to eql(txt.split.each_cons(n).map{|e| e.join " " })
      end
    }
    it "should handle multiple gram sizes at once" do
      token = tokenizer.do("lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod", gram: [1,2])
      expected_token = ["lorem", "ipsum", "dolor", "sit", "amet", "consectetur",
                        "adipisicing", "elit", "sed", "do", "eiusmod",
                        'lorem ipsum', 'dolor sit', 'amet consectetur',
                        'adipisicing elit', 'sed do']
      expect(token).to eql(expected_token)

    end
  end
end
