module AbstractReflection
  # A mirror class. It is the most generic mirror and should be able
  # to reflect on any object you can get at in a given system.
  module ObjectMirror
    include Mirror

    # @return [FieldMirror] the instance variables of the object
    def variables
      raise CapabilitiesExceeded
    end

    # @return [FieldMirror] the class variables of the object or its class
    def class_variables
      raise CapabilitiesExceeded
    end

    # @return [Class] the actual runtime class object
    def target_class
      raise CapabilitiesExceeded
    end

    # Searches the system for other objects that have references to
    # this one.
    #
    # @return [Array<ObjectMirror>]
    def objects_with_references
    end

    # Returns the transitive closure (the full object tree under this
    # object, without duplicates).
    #
    # @return [Hash<ObjectMirror => Hash<...,...>>] nested hashes
    def transitive_closure
    end

    # Searches for a reference path from this object to another given
    # object.
    #
    # @return [Array<ObjectMirror>, NilClass] the object path or nil, if none
    def path_to(obj)
    end

    # The instance_eval known from Ruby. Should return the result or a
    # representation thereof.
    def instance_eval
    end
  end
end
