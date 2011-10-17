module AbstractReflection
  # Reflecting on the compiler, both in a general sense (to just
  # compile things) and in specific states. It should be possible to
  # get a compiler instance and associated state from e.g. the
  # execution of a thread.
  # 
  # This class should also allow access to information about JIT,
  # caches etc
  module CompilerMirror
    include Mirror

    # Your Kernel#eval, but only compiles and returns
    # the compiled method object.
    #
    # return [MethodMirror]
    def compile(source)
      raise CapabilitiesExceeded
    end

    # For a specific compiler state, this holds the current module
    # definition stack. This should be a list of modules in which the
    # Thread, that belongs to this compiler state, is currently
    # nested. The first element is the module that would be target for
    # the next method definition.
    #
    # return [Array<ClassMirror>]
    def module_scope
      raise CapabilitiesExceeded
    end
  end
end
