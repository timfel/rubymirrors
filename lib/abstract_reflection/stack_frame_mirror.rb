module AbstractReflection
  module StackFrameMirror
    def restart
      raise CapabilitiesExceeded
    end

    def pop
      raise CapabilitiesExceeded
    end

    def step(length = :over)
      raise CapabilitiesExceeded
    end

    def receiver
      raise CapabilitiesExceeded
    end

    def self
      raise CapabilitiesExceeded
    end

    def selector
      raise CapabilitiesExceeded
    end

    def ip_offset
      raise CapabilitiesExceeded
    end

    def step_offset
      raise CapabilitiesExceeded
    end

    def source_offset
      raise CapabilitiesExceeded
    end

    def arguments
      raise CapabilitiesExceeded
    end

    def locals
      raise CapabilitiesExceeded
    end

    def variable_context
      raise CapabilitiesExceeded
    end

    def binding
      raise CapabilitiesExceeded
    end

    def method
      raise CapabilitiesExceeded
    end
  end
end
