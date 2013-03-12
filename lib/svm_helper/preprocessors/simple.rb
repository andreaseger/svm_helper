# encoding: UTF-8
module Preprocessor
  #
  # Preprocessor which just cleans to text
  #
  # @author Andreas Eger
  #
  class Simple
    # filters most gender stuff
    GENDER_FILTER = %r{(\(*(m|w)(\/|\|)(w|m)\)*)|(/-*in)|\(in\)}
    # filters most wierd symbols
    SYMBOL_FILTER = %r{/|-|–|:|\+|!|,|\.|\*|\?|/|·|\"|„|•||\||(\S*(&|;)\S*)}
    # urls and email filter
    URL_FILTER = /(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/
    EMAIL_FILTER = /([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})/
    # filter for new lines
    NEW_LINES = /(\r\n)|\r|\n/
    # extract words from brackets
    WORDS_IN_BRACKETS = /\(([a-zA-Z]+)\)/
    # filters multiple whitesspace
    WHITESPACE = /(\s| )+/
    # filters all kind of XMl/HTML tags
    XML_TAG_FILTER = /<(.*?)>/
    # filter for used job tokens
    CODE_TOKEN_FILTER = /\[[^\]]*\]|\([^\)]*\)|\{[^\}]*\}|\S*\d+\w+/

    def initialize args={}
    end

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
    def process jobs, classification=:function, options={}
      parallel = options.fetch(:parallel) {false}
      parallel = :threads if RUBY_PLATFORM == 'java' && parallel == :processes
      if jobs.respond_to? :map
        case parallel
        when :processes
          Parallel.map(jobs) {|job| process_job job, classification }
        when :threads
          Parallel.map(jobs, in_threads: (ENV['OMP_NUM_THREADS'] || 2) ) {|job| process_job job, classification }
        else
          jobs.map {|job| process_job job, classification }
        end
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
            gsub(WORDS_IN_BRACKETS, '\1').
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
          .gsub(EMAIL_FILTER,'')
          .gsub(URL_FILTER,'')
          .gsub(GENDER_FILTER,'')
          .gsub(NEW_LINES,'')
          .gsub(SYMBOL_FILTER,' ')
          .gsub(WHITESPACE,' ')
          .gsub(WORDS_IN_BRACKETS, '\1')
          .gsub(CODE_TOKEN_FILTER,'')
          .downcase
          .strip
    end

    private
    def process_job job, classification
      PreprocessedData.new(
        data: [ clean_title(job.title), clean_description(job.description) ],
        ids: {
          industry: job.classification_id(:industry),
          function: job.classification_id(:function),
          career_level: job.classification_id(:career_level) },
        labels: {
          industry: job.label(:industry),
          function: job.label(:function),
          career_level: job.label(:career_level) }
      ).tap{|e| e.send("#{classification}!")}
    end
  end
end
