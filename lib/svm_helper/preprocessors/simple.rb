# encoding: UTF-8
module Preprocessor
  #
  # Preprocessor which just cleans to text
  #
  # @author Andreas Eger
  #
  class Simple
    THREAD_COUNT = (ENV['OMP_NUM_THREADS'] || 2).to_i
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
      @parallel = args.fetch(:parallel){false}
    end

    def label
      "simple"
    end
    #
    # cleans provided jobs
    # @overload process(jobs, classification)
    #   @param  jobs [Hash] single Job
    #   @option title
    #   @option description
    #   @option id
    #   @option label
    #   @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @overload process(jobs, classification)
    #   @param  jobs [Array<Hash>] list of Jobs
    #   @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    #
    # @return [Array<PreprocessedData>] list of processed job data - or singe job data
    def process jobs
      if jobs.is_a? Array
        process_jobs jobs
      else
        process_job jobs
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
    def process_jobs jobs
      if @parallel && RUBY_PLATFORM == 'java'
        Parallel.map(jobs, in_threads: THREAD_COUNT ) {|job| process_job job }
      elsif @parallel
        Parallel.map(jobs, in_processes: THREAD_COUNT ) {|job| process_job job }
      else
        jobs.map {|job| process_job job }
      end
    end

    def process_job job
      PreprocessedData.new(
        data: [clean_title(job[:title]), clean_description(job[:description])],
        id: job[:id],
        label: job[:label]
      )
    end
  end
end
