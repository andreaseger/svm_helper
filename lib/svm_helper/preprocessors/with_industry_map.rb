require_relative 'simple'
module Preprocessor
  #
  # Preprocessor Base Class
  #
  # @author Andreas Eger
  #
  class WithIndustryMap < Simple
    attr_reader :industry_map

    #
    # @param  args [Hash] options hash
    # @option args [Hash] :industry_map mapping for the tree like industry ids to continuous ones
    def initialize args={}
      @industry_map = args.fetch(:industry_map){ Hash[Pjpp::Industry.select(:id).all.map(&:id).sort.map.with_index{|e,i| [e,i]}] }
    end

    def map_industry_id(id)
      @industry_map[id]
    end
    def label
      "with_industry_map"
    end

    private
    def process_job job, classification
      PreprocessedData.new(
        data: [ clean_title(job.title), clean_description(job.description) ],
        ids: {
          industry: map_industry_id(job.classification_id(:industry)),
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