# encoding: UTF-8
require_relative 'base'
module Preprocessor
  #
  # Preprocessor which just cleans to text
  #
  # @author Andreas Eger
  #
  class Simple < Preprocessor::Base
    # filters most gender stuff
    GENDER_FILTER = %r{(\(*(m|w)(\/|\|)(w|m)\)*)|(/-*in)|\(in\)}
    # filters most wierd symbols
    SYMBOL_FILTER = %r{/|-|–|:|\+|!|,|\.|\*|\?|/|·|\"|„|•||\|&amp;}
    # filters multiple whitesspace
    WHITESPACE = /(\s| )+/
    # filters all kind of XMl/HTML tags
    XML_TAG_FILTER = /<(.*?)>/
    # filter for used job tokens
    CODE_TOKEN_FILTER = /\[.*\]|\(.*\)|\{.*\}|\d+\w+/
    # filter for new lines
    NEW_LINES = /(\r\n)|\r|\n/

    def label
      "simple"
    end
    #
    # cleans provided jobs
    # @overload process(jobs, classification)
    #   @param  jobs [Job] single Job
    #   @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @overload process(jobs, classification)
    #   @param  jobs [Array<Job>] list of Jobs
    #   @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    #
    # @return [Array<PreprocessedData>] list of processed job data - or singe job data
    def process jobs, classification=:function
      if jobs.respond_to? :map
        jobs.map{|job| process_job job, classification }
      else
        process_job jobs, classification
      end
    end

    #
    # converts string into a cleaner version
    # @param  title [String] job title
    #
    # @return [String] clean and lowercase version of input
    def clean_title title
      title.gsub(GENDER_FILTER,'').
            gsub(SYMBOL_FILTER,'').
            gsub(/\(([a-zA-Z]+)\)/, '\1').
            gsub(CODE_TOKEN_FILTER,'').
            gsub(WHITESPACE,' ').
            downcase.
            strip
    end
    #
    # converts string into a cleaner version
    # @param  desc [String] job description
    #
    # @return [String] clean and lowercase version of input
    def clean_description desc
      desc.gsub(XML_TAG_FILTER,' ')
          .gsub(GENDER_FILTER,'')
          .gsub(NEW_LINES,'')
          .gsub(SYMBOL_FILTER,' ')
          .gsub(WHITESPACE,' ')
          .gsub(/\(([a-zA-Z ]+)\)/, '\1')
          .gsub(CODE_TOKEN_FILTER,'')
          .downcase
          .strip
    end

    private
    def process_job job, classification
      PreprocessedData.new(
        data: [ clean_title(job.title), clean_description(job.description) ],
        ids: {
          industry: map_industry_id(job.original_industry_id),
          function: job.original_function_id,
          career_level: job.original_career_level_id },
        labels: {
          industry: correct?(job, :industry),
          function: correct?(job, :function),
          career_level: correct?(job, :career_level) }
      ).tap{|e| e.send("#{classification}!")}
    end
  end
end
