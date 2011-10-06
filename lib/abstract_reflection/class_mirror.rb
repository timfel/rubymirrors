module AbstractReflection
  # A specific mirror for a class, that includes all the capabilites
  # and information we can gather about classes.
  module ClassMirror
    include ObjectMirror

    # The known instance variables of this class. Ruby doesn't have a
    # fixed number of instance variables, but static or runtime
    # anlysis can give us a good idea what kind of variables we can
    # expect.
    #
    # @return [FieldMirror]
    def instance_variables
      raise CapabilitiesExceeded
    end

    # The known class variables. @see #instance_variables
    #
    # @return [FieldMirror]
    def class_variables
      raise CapabilitiesExceeded
    end

    # The known class variables. @see #instance_variables
    #
    # @return [FieldMirror]
    def class_instance_variables
      raise CapabilitiesExceeded
    end

    # The source files this class is defined and/or extended in.
    # 
    # @return [Array<String,File>]
    def source_files
      raise CapabilitiesExceeded
    end

    # The singleton class of this class
    #
    # @return [ClassMirror]
    def singleton_class
      raise CapabilitiesExceeded
    end

    # Predicate to determine whether the subject is a singleton class
    #
    # @return [true,false]
    def singleton_class?
    end

    # The inverse of #singleton_class.
    #
    # @return [ClassMirror]
    def singleton_instance
    end

    # The namespace of this class. Provides direct access to the
    # enclosing namespace.
    #
    # @return [ClassMirror]
    def namespace
    end

    # The full nesting.
    #
    # @return [Array<ClassMirror>]
    def nesting
      raise CapabilitiesExceeded
    end

    # The classes nested within the subject.
    #
    # @return [Array<ClassMirror>]
    def nested_classes
      raise CapabilitiesExceeded
    end

    # The mixins included in the ancestors of this class.
    #
    # @return [Array<ClassMirror>]
    def mixins
      raise CapabilitiesExceeded
    end

    # The direct superclass
    #
    # @return [ClassMirror]
    def superclass
      raise CapabilitiesExceeded
    end

    # The known subclasses
    #
    # @return [Array<ClassMirror>]
    def subclasses
      raise CapabilitiesExceeded
    end

    # The list of ancestors
    #
    # @return [Array<ClassMirror>]
    def ancestors
      raise CapabilitiesExceeded
    end

    # The constants defined within this class. This includes nested
    # classes and modules, but also all other kinds of constants.
    #
    # @return [Array<FieldMirror>]
    def constants
      raise CapabilitiesExceeded
    end

    # The instance methods of this class. To get to the class methods,
    # ask the #singleton_class for its methods.
    #
    # @return [Array<MethodMirror>]
    def methods
      raise CapabilitiesExceeded
    end

    # The method dictionary. Maps names to methods. Should ideally be
    # writable.
    def method_dictionary
      raise CapabilitiesExceeded
    end
  end
end
