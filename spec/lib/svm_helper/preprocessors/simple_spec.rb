# encoding: UTF-8
require 'spec_helper'

describe Preprocessor::Simple do
  it_behaves_like 'a preprocessor'

  let(:simple){Preprocessor::Simple.new}
  it 'should have process implemented' do
    expect{simple.process([])}.not_to raise_error
  end
  it 'should have a label' do
    expect(simple.label).to eq('SvmHelper::Preprocessor::Simple')
  end
  context 'correct flag' do
    before(:each) do
      @jobs = FactoryGirl.build_list :entry, 3
    end
    it 'should work with jobs with quality check' do
      expect{simple.process(@jobs)}.not_to raise_error
    end
    it 'should set labels to true if quality check exists and is true' do
      @jobs.each{|e| e[:label] = true}
      simple.process(@jobs).each{|e| expect(e.correct).to be_truthy}
    end
    it 'should set labels to false if quality check exists and is false' do
      @jobs.each{|e| e[:label] = false}
      simple.process(@jobs).each{|e| expect(e.correct).to be_falsey}
    end
  end

  context 'processing' do
    let(:jobs){FactoryGirl.build_list(:entry, 3)}
    before(:each) do
      allow(simple).to receive(:clean_title)
      allow(simple).to receive(:clean_text)
    end
    it 'should call clean_and_tokenize' do
      expect(simple).to receive(:clean_and_tokenize).exactly(3).times
      simple.process(jobs)
    end
    # it 'should call clean_title on each job' do
    #   expect(simple).to receive(:clean_title).exactly(3).times
    #   simple.process(jobs)
    # end
    # it 'should call clean_text on each job' do
    #   expect(simple).to receive(:clean_text).exactly(3).times
    #   simple.process(jobs)
    # end
  end

  # context '#clean_title' do
  #   it 'should be downcased' do
  #     entry = FactoryGirl.build(:entry_title_downcasing)
  #     simple.clean_title(entry[:title]).should eq(entry[:clean_title])
  #   end
  #   [FactoryGirl.build(:entry_title_w_gender),
  #    FactoryGirl.build(:entry_title_w_gender_brackets),
  #    FactoryGirl.build(:entry_title_w_gender_pipe),
  #    FactoryGirl.build(:entry_title_w_gender_pipe_brackets),
  #    FactoryGirl.build(:entry_title_w_gender2),
  #    FactoryGirl.build(:entry_title_w_gender2_dash),
  #    FactoryGirl.build(:entry_title_w_gender2_brackets),
  #    FactoryGirl.build(:entry_title_w_code),
  #    FactoryGirl.build(:entry_title_w_code2),
  #    FactoryGirl.build(:entry_title_w_code3),
  #    FactoryGirl.build(:entry_title_w_dash),
  #    FactoryGirl.build(:entry_title_w_slash),
  #    FactoryGirl.build(:entry_title_w_senior_brackets),
  #    FactoryGirl.build(:entry_title_var_0),
  #    FactoryGirl.build(:entry_title_w_special),
  #    FactoryGirl.build(:entry_title_w_percent)].each do |entry|
  #     it "should cleanup '#{entry[:title]}'" do
  #       simple.clean_title(entry[:title]).should eq(entry[:clean_title])
  #     end
  #   end
  # end
  context '#clean_text' do
    let(:jobs) do
      [FactoryGirl.build(:entry_text_w_tags),
       FactoryGirl.build(:entry_text_w_adress),
       FactoryGirl.build(:entry_text_w_special),
       FactoryGirl.build(:entry_text_w_code_token),
       FactoryGirl.build(:entry_text_w_gender)]
    end
    it 'should call strip_stopwords' do
      expect(simple).to receive(:strip_stopwords)
      simple.clean_text(jobs[0][:text])
    end
    it 'should remove html/xml tags' do
      desc = simple.clean_text(jobs[0][:text]).join ' '
      expect(desc).not_to match(/<(.*?)>/)
    end
    it 'should remove new lines' do
      desc = simple.clean_text(jobs[0][:text]).join ' '
      expect(desc).not_to match(/\r\n|\n|\r/)
    end
    it 'should remove all special characters' do
      desc = simple.clean_text(jobs[2][:text]).join ' '
      expect(desc).not_to match(/[^a-z öäü]/i)
    end
    it 'should remove gender tokens' do
      desc = simple.clean_text(jobs[3][:text]).join ' '
      expect(desc).not_to match(%r{(\(*(m|w)(\/|\|)(w|m)\)*)|(/-*in)|\(in\)})
    end
    it 'should remove job code token' do
      desc = simple.clean_text(jobs[4][:text]).join ' '
      expect(desc).not_to match(/\[.*\]|\(.*\)|\{.*\}|\d+\w+/)
    end
    it 'should be downcased' do
      desc = simple.clean_text(jobs[2][:text]).join ' '
      expect(desc).not_to match(/[^a-z öäü]/)
    end
  end

  context 'strip_stopwords' do
    it "should remove words like 'and' from the text" do
      expect(simple.strip_stopwords('Dogs and cats')).to eq(%w(Dogs cats))
    end
  end
  context 'parallel' do
    let(:parallel){Preprocessor::Simple.new(parallel: true)}

    let(:jobs) do
      [FactoryGirl.build(:entry_text_w_tags),
       FactoryGirl.build(:entry_text_w_adress),
       FactoryGirl.build(:entry_text_w_special),
       FactoryGirl.build(:entry_text_w_code_token),
       FactoryGirl.build(:entry_text_w_gender)]
    end
    it 'should be the same parallelized' do
      single = simple.process(jobs)
      p_data = parallel.process(jobs)
      single.each.with_index{|e, i| expect(e.token).to eq(p_data[i].token)}
    end
  end
  context 'id_mapping' do
    let(:preprocessor){Preprocessor::Simple.new(ip_map: { 1423 => 3, 523 => 54 })}
    let(:job){FactoryGirl.build(:entry)}
    let(:jobs){[job]}
    it 'should make use of a industry_map' do
      expect(preprocessor).to receive(:map_id)
      preprocessor.process(jobs)
    end
  end
end
