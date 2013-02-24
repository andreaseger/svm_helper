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
      @industry_map = args.fetch(:industry_map){ Hash[Pjpp::Industry.pluck(:id).sort.map.with_index{|e,i| [e,i]}] }
    end

    def map_industry_id(id)
      @industry_map[id]
    end
  end
end