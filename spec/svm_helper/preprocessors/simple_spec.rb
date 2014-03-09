# encoding: UTF-8
require 'spec_helper'

describe Preprocessor::Simple do
  it_behaves_like 'a preprocessor'

  let(:simple) { Preprocessor::Simple.new }
  it "should have process implemented" do
    -> { simple.process([]) }.should_not raise_error
  end
  it "should have a label" do
    expect(simple.label).to eq("Preprocessor::Simple")
  end
  context "correct flag" do
    before(:each) do
      @jobs = FactoryGirl.build_list :job, 3
    end
    it "should work with jobs with quality check" do
      -> {simple.process(@jobs) }.should_not raise_error
    end
    it "should set labels to true if quality check exists and is true" do
      @jobs.map!{|e| e[:label] = true;e }
      simple.process(@jobs).each{|e| e.correct.should be_true}
    end
    it "should set labels to false if quality check exists and is false" do
      @jobs.map!{|e| e[:label] = false;e }
      simple.process(@jobs).each{|e| e.correct.should be_false}
    end
  end

  context "processing" do
    let(:jobs) { FactoryGirl.build_list(:job,3) }
    before(:each) do
      simple.stubs(:clean_title)
      simple.stubs(:clean_description)
    end
    it "should call clean_title on each job" do
      simple.expects(:clean_title).times(3)
      simple.process(jobs)
    end
    it "should call clean_description on each job" do
      simple.expects(:clean_description).times(3)
      simple.process(jobs)
    end
  end


  context "#clean_title" do
    it "should be downcased" do
      job = FactoryGirl.build(:job_title_downcasing)
      simple.clean_title(job[:title]).should eq(job[:clean_title])
    end
    [ FactoryGirl.build(:job_title_w_gender),
      FactoryGirl.build(:job_title_w_gender_brackets),
      FactoryGirl.build(:job_title_w_gender_pipe),
      FactoryGirl.build(:job_title_w_gender_pipe_brackets),
      FactoryGirl.build(:job_title_w_gender2),
      FactoryGirl.build(:job_title_w_gender2_dash),
      FactoryGirl.build(:job_title_w_gender2_brackets),
      FactoryGirl.build(:job_title_w_code),
      FactoryGirl.build(:job_title_w_code2),
      FactoryGirl.build(:job_title_w_code3),
      FactoryGirl.build(:job_title_w_dash),
      FactoryGirl.build(:job_title_w_slash),
      FactoryGirl.build(:job_title_w_senior_brackets),
      FactoryGirl.build(:job_title_var_0),
      FactoryGirl.build(:job_title_w_special),
      FactoryGirl.build(:job_title_w_percent)].each do |job|
      it "should cleanup '#{job[:title]}'" do
        simple.clean_title(job[:title]).should eq(job[:clean_title])
      end
    end
  end
  context "#clean_description" do
    let(:jobs) {
      [ FactoryGirl.build(:job_description_w_tags),
        FactoryGirl.build(:job_description_w_adress),
        FactoryGirl.build(:job_description_w_special),
        FactoryGirl.build(:job_description_w_code_token),
        FactoryGirl.build(:job_description_w_gender) ]
    }
    it "should call strip_stopwords" do
      simple.expects(:strip_stopwords)
      simple.clean_description(jobs[0][:description])
    end
    it "should remove html/xml tags" do
      desc = simple.clean_description(jobs[0][:description]).join ' '
      desc.should_not match(/<(.*?)>/)
    end
    it "should remove new lines" do
      desc = simple.clean_description(jobs[0][:description]).join ' '
      desc.should_not match(/\r\n|\n|\r/)
    end
    it "should remove all special characters" do
      desc = simple.clean_description(jobs[2][:description]).join ' '
      desc.should_not match(/[^a-z öäü]/i)
    end
    it "should remove gender tokens" do
      desc = simple.clean_description(jobs[3][:description]).join ' '
      desc.should_not match(%r{(\(*(m|w)(\/|\|)(w|m)\)*)|(/-*in)|\(in\)})
    end
    it "should remove job code token" do
      desc = simple.clean_description(jobs[4][:description]).join ' '
      desc.should_not match(/\[.*\]|\(.*\)|\{.*\}|\d+\w+/)
    end
    it "should be downcased" do
      desc = simple.clean_description(jobs[2][:description]).join ' '
      desc.should_not match(/[^a-z öäü]/)
    end
  end

  context "strip_stopwords" do
    it "should remove words like 'and' from the text" do
      simple.strip_stopwords("Dogs and cats").should == %w(Dogs cats)
    end
  end
  context "parallel" do
      let(:parallel) { Preprocessor::Simple.new(parallel: true) }

    let(:jobs) {
      [ FactoryGirl.build(:job_description_w_tags),
        FactoryGirl.build(:job_description_w_adress),
        FactoryGirl.build(:job_description_w_special),
        FactoryGirl.build(:job_description_w_code_token),
        FactoryGirl.build(:job_description_w_gender) ]
    }
    it "should be the same parallelized" do
      single = simple.process(jobs)
      p_data = parallel.process(jobs)
      single.each.with_index { |e,i| e.data.should == p_data[i].data }
    end
  end
  context "id_mapping" do
    let(:preprocessor) { Preprocessor::Simple.new(ip_map: {1423=>3, 523=>54}) }
    let(:job) { FactoryGirl.build(:job) }
    let(:jobs) { [job] }
    it "should make use of a industry_map" do
      preprocessor.expects(:map_id)
      preprocessor.process(jobs)
    end
  end
end