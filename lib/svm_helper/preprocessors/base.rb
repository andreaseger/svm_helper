module Preprocessor
  #
  # Preprocessor Base Class
  #
  # @author Andreas Eger
  #
  class Base
    attr_reader :industry_map

    #
    # @param  args [Hash] options hash
    # @option args [Hash] :industry_map mapping for the tree like industry ids to continuous ones
    def initialize args={}
      @industry_map = args.fetch(:industry_map){ Hash[Pjpp::Industry.select(:id).all.map(&:id).sort.map.with_index{|e,i| [e,i]}] }
    end
    #
    # checks if the job was classified correctly
    # @param job [Job]
    # @param classification [symbol]
    #
    # @return [Boolean]
    def correct? job, classification
      if (qc = job.qc_job_check).nil?
        false
      else
        qc.send("wrong_#{classification}_id").nil?
      end
    end

    def map_industry_id(id)
      @industry_map[id]
    end
  end
end