module AbstractReflection
  # Reflective access to the GC. This includes statistics, runtime
  # behavior observation and triggering specific GC functionality.
  module GCMirror
    # Trigger a GC run
    # @return stats about cleaned objects, freed memory, etc
    def collect_garbage
    end

    # Run memory compaction
    # @return info about freed memory, moved pages, etc
    def compact_memory
    end    
  end
end
