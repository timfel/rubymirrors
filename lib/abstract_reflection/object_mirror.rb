module AbstractReflection
  # A generic class to reflect on any object
  module ObjectMirror
    include Mirror

    # @return [FieldMirror] the instance variables of the object
    def variables
      raise CapabilitiesExceeded
    end

    def class_variables
      raise CapabilitiesExceeded
    end

    def target_class
      raise CapabilitiesExceeded
    end

    def objects_with_references
    end

    def transitive_closure
    end

    def path_to(obj)
    end

    def instance_eval
    end
  end
end
