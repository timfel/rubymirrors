module AbstractReflection
  # A MethodMirror should reflect on methods, but in a more general
  # sense than the Method and UnboundMethod classes in Ruby are able
  # to offer.
  #
  # In actual execution, a method is pretty much every chunk of code,
  # even loading a file triggers a process not unlike compiling a
  # method (if only for the side-effects). Method mirrors should allow
  # access to the runtime objects, but also to their static
  # representations (bytecode, source, ...), their debugging
  # information and statistical information
  module MethodMirror
    # @return [String] The source code of this method
    def source
    end

    # @return [Fixnum] The source line
    def line
    end

    # @return [String] The method name
    def selector
    end

    # @return [String, File] The filename
    def file
    end

    # Queries the method for it's arguments and returns a list of
    # mirrors that hold name and value information.
    # 
    # @return [Array<FieldMirror>]
    def arguments
    end

    # Replace the sourcecode. This should be an in-place operation and
    # immediately visible to the system.
    def source= string
    end

    # Change the information about which file this method is stored
    # in. Possibly moves the method into the new file.
    def file= string
    end

    # Change the information about the line this method starts
    # at. Possibly moves the method.
    def line= string
    end

    # The offsets into the source code for method sends.
    def send_offsets
    end

    # The offsets into the source code for stepping in a debugger
    def step_offsets
    end

    # Allows setting a breakpoint in the method, optionally at an
    # offset.
    def break(step_offset = 1)
    end

    # Query the method for active breakpoints.
    def breakpoints
    end

    # Returns the class this method was defined in.
    # @return [ClassMirror]
    def in_class
    end

    # Predicate to determine whether this method was compiled for closure
    #
    # @return [true, false]
    def is_closure?
    end

    # The binding of the method. May be nil.
    #
    # @return [Binding, NilClass]
    def binding
    end

    # Predicate to determine whether this method is an alias.
    #
    # @return [true, false]
    def is_alias?
    end

    # Returns the original method to an alias, a proc, or an unbound
    # method object, or the method itself, if the previous options are
    # not applicable.
    #
    # @return [MethodMirror]
    def original_method
    end

    # Predicate to determine whether a given message is send within
    # this method. This should at least report all direct sends, but
    # might also report sends within #evals or through #send
    #
    # @return [true, false]
    def sends_message?(string)
    end
  end
end
