module AbstractReflection
  # A class to reflect on instance, class, and class instance variables,
  # as well as constants.
  module FieldMirror
    def value
      raise CapabilitiesExceeded
    end

    def value= obj
      raise CapabilitiesExceeded
    end

    def public?
      raise CapabilitiesExceeded
    end

    def private?
      raise CapabilitiesExceeded
    end

    def protected?
      raise CapabilitiesExceeded
    end

    def writable?
      true
    end

    def delete
      raise CapabilitiesExceeded
    end
  end
end
