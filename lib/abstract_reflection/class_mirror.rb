module AbstractReflection
  module ClassMirror
    include ObjectMirror

    def instance_variables
      raise CapabilitiesExceeded
    end

    def class_variables
      raise CapabilitiesExceeded
    end

    def class_instance_variables
      raise CapabilitiesExceeded
    end

    def source_files
      raise CapabilitiesExceeded
    end

    def singleton_class
      raise CapabilitiesExceeded
    end

    def singleton_class?
    end

    def singleton_instance
    end

    def namespace
    end
    
    def nesting
      raise CapabilitiesExceeded
    end

    def nested_classes
      raise CapabilitiesExceeded
    end

    def mixins
      raise CapabilitiesExceeded
    end

    def superclass
      raise CapabilitiesExceeded
    end

    def subclasses
      raise CapabilitiesExceeded
    end

    def ancestors
      raise CapabilitiesExceeded
    end

    def constants
      raise CapabilitiesExceeded
    end

    def methods
      raise CapabilitiesExceeded
    end

    def method_dictionary
      raise CapabilitiesExceeded
    end
  end
end
