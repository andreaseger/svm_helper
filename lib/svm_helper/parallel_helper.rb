module ParallelHelper
  THREAD_COUNT = (ENV['OMP_NUM_THREADS'] || 2).to_i
  def p_map_with_index data, &block
    if parallel? && RUBY_PLATFORM == 'java'
      Parallel.map_with_index(data, in_threads: THREAD_COUNT ){|e,i| yield e,i }
    elsif parallel?
      Parallel.map_with_index(data, in_processes: THREAD_COUNT ){|e,i| yield e,i }
    else
      data.map.with_index {|e,i| yield e,i }
    end
  end
  def p_map data, &block
    if parallel? && RUBY_PLATFORM == 'java'
      Parallel.map(data, in_threads: THREAD_COUNT ){|e| yield e }
    elsif parallel?
      Parallel.map(data, in_processes: THREAD_COUNT ){|e| yield e }
    else
      data.map {|e| yield e }
    end
  end
  def parallel?
    defined?(Parallel) == 'constant' && @parallel
  end
end