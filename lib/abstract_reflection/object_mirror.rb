module AbstractReflection
  # A generic class to reflect on any object
  module ObjectMirror
    include Mirror

    # @return [FieldMirror] the instance variables of the object
    def variables
      raise CapabilitiesExceeded
    end
  end
end

