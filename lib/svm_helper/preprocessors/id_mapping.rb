require_relative 'simple'
module Preprocessor
  #
  # Preprocessor Base Class
  #
  # @author Andreas Eger
  #
  class IDMapping < Simple
    attr_reader :id_map

    #
    # @param  args [Hash] options hash
    # @option args [Hash] :industry_map mapping for the tree like industry ids to continuous ones
    def initialize id_map, args={}
      super(args)
      @id_map = id_map
    end

    def map_id(id)
      @id_map[id]
    end
    def label
      "with_id_mapping"
    end

    private
    def process_job job
      PreprocessedData.new(
        data: [clean_title(job[:title]), clean_description(job[:description])],
        id: map_id(job[:id]),
        label: job[:label]
      )
    end
  end
end