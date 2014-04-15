# TODO check if rbx can use lingua
case RUBY_ENGINE
when 'ruby'

  require 'lingua/stemmer'
  Stemmer = Lingua::Stemmer

when 'jruby'

  require 'jruby-stemmer'
  class Stemmer
    # basically from https://github.com/caius/jruby-stemmer/blob/master/lib/jruby-stemmer.rb
    def initialize(language: 'en')
      p "only 'en' stemming available for jruby" if language != 'en'
      @stemmer = Java::OrgTartarusMartinPorter_Stemmer::Stemmer.new
    end

    def stem(string)
      java_string = string.to_java_string
      stemmer.add java_string.toCharArray, java_string.length
      stemmer.stem
      stemmer.to_string
    end
  private
    def stemmer
      @stemmer
    end
  end
end
