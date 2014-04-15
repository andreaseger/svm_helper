# encoding: UTF-8
require_relative 'base'
module Preprocessor
  #
  # Preprocessor which just cleans to text
  #
  # @author Andreas Eger
  #
  class Simple < Base
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
    XML_TAG_FILTER = /<[^>]+?>/
    # filter for used job tokens
    CODE_TOKEN_FILTER = /\[[^\]]*\]|\([^\)]*\)|\{[^\}]*\}|\S*\d+\w+/

    # stopword file
    # TODO: use File.expand_path
    STOPWORD_LOCATION = File.join(File.dirname(__FILE__), '..', 'stopwords')
    attr_accessor :language

    def initialize(args={})
      super
      @language = args.fetch(:language){'en'}
      @stopwords ||= IO.read(File.join(STOPWORD_LOCATION, @language)).split
      @id_map = args.fetch(:id_map){false}
    end

    #
    # cleans provided jobs
    # @overload process(jobs)
    #   @param jobs [Array<Hash>] list of jobs
    # @overload process(job)
    #   @param [Hash] job
    #   @option job [String] title
    #   @option job [String] description
    #   @option job [Integer] id
    #   @option job [Symbol] label
    #
    # @return [Array<PreprocessedData>] list of processed job data
    def process(jobs)
      if jobs.is_a? Array
        p_map(jobs){|job| process_job job}
      else
        process_job jobs
      end
    end

    #
    # delete all stopwords and v. short words from given text
    # @param text [String] text to strip
    #
    # @return [Array<String>] Array of remaining words
    def strip_stopwords(text)
      (text.split - @stopwords).delete_if{|e| e.size <= 2}
    end

    #
    # converts string into a cleaner version
    # @param  title [String] job title
    #
    # @return [String] clean and lowercase version of input
    def clean_title(title)
      title.gsub(GENDER_FILTER, '').
            gsub(SYMBOL_FILTER, '').
            gsub(WORDS_IN_BRACKETS, '\1').
            gsub(CODE_TOKEN_FILTER, '').
            gsub(WHITESPACE, ' ').
            downcase.
            strip
    end
    #
    # converts string into a cleaner version
    # @param  desc [String] job description
    #
    # @return [String] clean and lowercase version of input
    def clean_description(desc)
      strip_stopwords(
        desc.gsub(XML_TAG_FILTER, ' ')
            .gsub(EMAIL_FILTER, '')
            .gsub(URL_FILTER, '')
            .gsub(GENDER_FILTER, '')
            .gsub(NEW_LINES, '')
            .gsub(SYMBOL_FILTER, ' ')
            .gsub(WHITESPACE, ' ')
            .gsub(WORDS_IN_BRACKETS, '\1')
            .gsub(CODE_TOKEN_FILTER, '')
            .downcase
            .strip
        )
    end

  private

    def map_id(id)
      if @id_map
        @id_map[id]
      else
        id
      end
    end

    def process_job(job)
      PreprocessedData.new(
        data: [clean_title(job[:title]), clean_description(job[:description])],
        id: map_id(job[:id]),
        correct: job[:label]
      )
    end
  end
end
