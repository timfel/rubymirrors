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
  end
end
