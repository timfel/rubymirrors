module AbstractReflection
  module ThreadMirror
    def stop
      raise CapabilitiesExceeded
    end

    def run
      raise CapabilitiesExceeded
    end

    def kill
      raise CapabilitiesExceeded
    end

    def return_value
      raise CapabilitiesExceeded
    end

    def status
      raise CapabilitiesExceeded
    end

    def stack
      raise CapabilitiesExceeded
    end

    def step(length = :over)
      raise CapabilitiesExceeded
    end

    def breakpoints
      raise CapabilitiesExceeded
    end

    def thread_data
      raise CapabilitiesExceeded
    end

    def compiler
      raise CapabilitiesExceeded
    end

    # Installs an exception block in the thread. This is no rescue,
    # the block will be executed for the given exception type, but it
    # will not prevent the exception from propagating through the
    # thread.
    #
    # @param [Exception, Array<Exception>] the exception(s) to rescue
    # @param [Block] the exception handler
    def handle_exception(e = Exception, &block)
      raise CapabilitiesExceeded
    end
  end
end
