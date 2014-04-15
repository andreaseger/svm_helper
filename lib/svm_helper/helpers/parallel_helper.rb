module ParallelHelper
  THREAD_COUNT = (ENV['OMP_NUM_THREADS'] || 2).to_i

  # works similar to map.with_index
  # @param [Enum] the enum to map over
  #
  # @return [Array] whatever the block does
  def p_map_with_index(data, &block)
    if parallel? && (@parallel == :threads || RUBY_ENGINE =~ /jruby|rbx/)
      Parallel.map_with_index(data, in_threads: THREAD_COUNT, &block )
    elsif parallel?
      Parallel.map_with_index(data, in_processes: THREAD_COUNT, &block )
    else
      data.map.with_index(&block)
    end
  end

  # works similar to map
  # @param [Enum] the enum to map over
  #
  # @return [Array] whatever the block does
  def p_map(data, &block)
    if parallel? && (@parallel == :threads || RUBY_ENGINE =~ /jruby|rbx/)
      Parallel.map(data, in_threads: THREAD_COUNT, &block )
    elsif parallel?
      Parallel.map(data, in_processes: THREAD_COUNT, &block )
    else
      data.map(&block)
    end
  end

  # checks if the parallel gem is loaded and parallel processing is enabled
  # via the @parallel instance variable
  def parallel?
    defined?(Parallel) == 'constant' && @parallel
  end
end
