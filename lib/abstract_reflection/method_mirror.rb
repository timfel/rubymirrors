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
    # @return [ClassMirror] The class this method was originally defined in
    def defining_class
      raise CapabilitiesExceeded
    end
    
    # @return [String] The source code of this method
    def source
      raise CapabilitiesExceeded
    end

    # @return [Fixnum] The source line
    def line
      raise CapabilitiesExceeded
    end

    # @return [String] The method name
    def selector
      raise CapabilitiesExceeded
    end

    # @return [String] The filename
    def file
      raise CapabilitiesExceeded
    end

    # Queries the method for it's arguments and returns a list of
    # mirrors that hold name and value information.
    # 
    # @return [Array<FieldMirror>]
    def arguments
      raise CapabilitiesExceeded
    end

    # Returns a field mirror with name and possibly value of the splat
    # argument, or nil, if there is none to this method.
    #
    # @return [FieldMirror, nil]
    def splat_argument
      raise CapabilitiesExceeded
    end

    # Returns names and values of the optional arguments.
    #
    # @return [Array<FieldMirror>, nil]
    def optional_arguments
      raise CapabilitiesExceeded
    end

    # Returns the name and possibly values of the required arguments
    # @return [Array<FieldMirror>, nil]
    def required_arguments
      raise CapabilitiesExceeded
    end

    # Return the value the block argument, or nil
    #
    # @return [FieldMirror, nil]
    def block_argument
      raise CapabilitiesExceeded
    end

    # Replace the sourcecode. This should be an in-place operation and
    # immediately visible to the system.
    def source= string
      raise CapabilitiesExceeded
    end

    # Change the information about which file this method is stored
    # in. Possibly moves the method into the new file.
    def file= string
      raise CapabilitiesExceeded
    end

    # Change the information about the line this method starts
    # at. Possibly moves the method.
    def line= string
      raise CapabilitiesExceeded
    end

    # The offsets into the source code for method sends.
    #
    # @return [Hash<String, Fixnum>] a hash of selector-offset pairs
    def send_offsets
      raise CapabilitiesExceeded
    end

    # The offsets into the source code for stepping in a debugger
    def step_offsets
      raise CapabilitiesExceeded
    end

    # Allows setting a breakpoint in the method, optionally at an
    # offset.
    def break(step_offset = 1)
      raise CapabilitiesExceeded
    end

    # Query the method for active breakpoints.
    def breakpoints
      raise CapabilitiesExceeded
    end

    # Returns the class this method was defined in.
    # @return [ClassMirror]
    def in_class
      raise CapabilitiesExceeded
    end

    # Predicate to determine whether this method was compiled for closure
    #
    # @return [true, false]
    def is_closure?
      raise CapabilitiesExceeded
    end

    # The binding of the method. May be nil.
    #
    # @return [Binding, NilClass]
    def binding
      raise CapabilitiesExceeded
    end

    # Predicate to determine whether this method is an alias.
    #
    # @return [true, false]
    def is_alias?
      raise CapabilitiesExceeded
    end

    # Returns the original method to an alias, a proc, or an unbound
    # method object, or the method itself, if the previous options are
    # not applicable.
    #
    # @return [MethodMirror]
    def original_method
      raise CapabilitiesExceeded
    end

    # Predicate to determine whether a given message is send within
    # this method. This should at least report all direct sends, but
    # might also report sends within #evals or through #send
    #
    # @return [true, false]
    def sends_message?(string)
      raise CapabilitiesExceeded
    end

    # Each method contributes a certain percentage to the runtime of
    # the system. This method can be used to query the system for the
    # percentage of the mirrored method (in the range 0 < p < 1). If
    # the number is closer to one, that means that the system spends a
    # considerable amount of time executing this method. This method
    # does not consider how often a method is called, i.e. a high
    # share doesn't tell you whether the method is slow or if it is
    # just called very often.
    #
    # @return [Time]
    def execution_time_share
      raise CapabilitiesExceeded
    end

    # The absolute, total time this method was executed (on top of the
    # stack)
    #
    # @return [Time]
    def execution_time
      raise CapabilitiesExceeded
    end

    # The average time each method invocation executes the method,
    # before returning.
    #
    # @return [Time]
    def execution_time_average
      raise CapabilitiesExceeded
    end

    # The number of times this method has been called. Not
    # neccessarily an exact number (to allow for optimizations), but
    # should at least give an indication.
    #
    # @return [Fixnum]
    def invocation_count
      raise CapabilitiesExceeded
    end

    # If this method was JITed, this should return the native code
    # location. nil, if this method was not jitted,
    # CapabilitiesExceeded should be thrown for implementations that
    # do not have a JIT.
    def native_code
      raise CapabilitiesExceeded
    end

    # If this method was compiled into a VM bytecode representation,
    # return an object describing the bytecode. Like #native_code,
    # this should raise a CapabilitiesExceeded only for implementations
    # that do not have a bytecode representation.
    def bytecode
      raise CapabilitiesExceeded
    end

    # The AST representation of this method.
    def ast
      raise CapabilitiesExceeded
    end

    def public?
      raise CapabilitiesExceeded
    end

    def public!
      raise CapabilitiesExceeded
    end

    def private?
      raise CapabilitiesExceeded
    end

    def private!
      raise CapabilitiesExceeded
    end

    def protected?
      raise CapabilitiesExceeded
    end

    def protected!
      raise CapabilitiesExceeded
    end

    def delete
      raise CapabilitiesExceeded
    end
  end
end
