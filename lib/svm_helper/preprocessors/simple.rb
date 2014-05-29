# encoding: UTF-8
require_relative 'base'
module SvmHelper
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
      SYMBOL_FILTER = %r{/|-|_|–|:|\+|!|,|\.|\*|\?|/|·|\"|„|•||\||(\S*(&|;)\S*)}
      # urls and email filter
      URL_FILTER = %r{(https?://)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*/?}
      EMAIL_FILTER = /([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})/
      # filter for new lines
      NEW_LINES = /(\r\n)|\r|\n/
      # extract words from brackets
      WORDS_IN_BRACKETS = /\(([a-zA-Z]+)\)/
      # filters multiple whitesspace
      WHITESPACE = /(\s| )+/
      # filters all kind of XMl/HTML tags
      XML_TAG_FILTER = /<[^>]+?>/
      # filter for used entry tokens
      CODE_TOKEN_FILTER = /\[[^\]]*\]|\([^\)]*\)|\{[^\}]*\}|\S*\d+\w+/

      # stopword file
      STOPWORD_LOCATION = File.join(__dir__, '..', 'stopwords')
      attr_accessor :language

      def initialize args={}
        super
        @language = args.fetch(:language){ 'en' }
        @stopwords ||= IO.read(File.join(STOPWORD_LOCATION, @language)).split
        @id_map = args.fetch(:id_map){ false }
      end

      #
      # cleans provided entries
      # @overload process(entries)
      #   @param entries [Array<Hash>] list of entries
      # @overload process(entry)
      #   @param [Hash] entry
      #   @option entry [String] text
      #   @option entry [Integer] id
      #   @option entry [Symbol] label
      #
      # @return [Array<PreprocessedData>] list of processed entry data
      def process entries
        if entries.is_a? Array
          p_map(entries){ |entry| process_entry entry }
        else
          process_entry entries
        end
      end

      #
      # delete all stopwords and v. short words from given text
      # @param text [String] text to strip
      #
      # @return [Array<String>] Array of remaining words
      def strip_stopwords text
        (tokenizer.do(text) - @stopwords).delete_if{ |e| e.size <= 3 }
      end

      #
      # converts string into a cleaner version
      # @param  title [String] entry title
      #
      # @return [String] clean and lowercase version of input
      # def clean_title title
      #   title.gsub(GENDER_FILTER, '').
      #         gsub(SYMBOL_FILTER, '').
      #         gsub(WORDS_IN_BRACKETS, '\1').
      #         gsub(CODE_TOKEN_FILTER, '').
      #         gsub(WHITESPACE, ' ').
      #         downcase.
      #         strip
      # end

      #
      # converts string into a cleaner version
      # @param  text [String] entry description
      #
      # @return [String] clean and lowercase version of input
      def clean_text text
        strip_stopwords(
          text.gsub(XML_TAG_FILTER, ' ').
               gsub(EMAIL_FILTER, '').
               gsub(URL_FILTER, '').
               gsub(GENDER_FILTER, '').
               gsub(NEW_LINES, '').
               gsub(SYMBOL_FILTER, ' ').
               gsub(WHITESPACE, ' ').
               gsub(WORDS_IN_BRACKETS, '\1').
               gsub(CODE_TOKEN_FILTER, '').
               downcase.
               strip
          )
      end

      def clean_and_tokenize data
        clean_text(data)
      end

    private

      def map_id id
        if @id_map
          @id_map[id]
        else
          id
        end
      end

      def process_entry entry
        PreprocessedData.new(
          token:   clean_and_tokenize(entry[:text]),
          id:      map_id(entry[:id]),
          correct: entry[:label]
        )
      end

      def tokenizer
        @tokenizer ||= Tokenizer.new
      end
    end
  end
end
