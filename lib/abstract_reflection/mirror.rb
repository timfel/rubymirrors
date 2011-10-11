module AbstractReflection
  # The basic mirror. This is the lib code. It is also the factory to
  # use for creating new mirrors on any kind of object. Its #reflect
  # class method will return an appropriate mirror for a given object,
  # provided one has been registered. The [ObjectMirror] class should
  # have been registered as the fallback case for any kind of object,
  # but that may depend on the specific API implementation.
  module Mirror
    module ClassMethods
      @@mirrors = []

      # Reflect on the passed object. This is the default factory for
      # creating new mirrors, and it will try and find the appropriate
      # mirror from the list of registered mirrors.
      #
      # @param [Object] the object to reflect upon. This need not be the
      #   actual object represented - it can itself be just a
      #   representation.  It is really up to the mirror to decide what to
      #   do with it
      def reflect(obj)
        target_mirror = nil
        @@mirrors.detect {|klass| target_mirror = klass.mirror_class(obj) }
        raise CapabilitiesExceeded if target_mirror.nil?
        target_mirror.new(obj)
      end

      # Decides whether the given class can reflect on [obj]
      # @param [Object] the object to reflect upon
      # @return [true, false]
      def reflects?(obj)
        @reflected_module === obj
      end

      # A shortcut to define reflects? behavior.
      # @param [Module] the module whose instances this mirror reflects
      def reflect!(klass)
        @reflected_module = klass
        register_mirror self
      end

      # Some objects may be more useful with a specialized kind of
      # mirror. This method can be used to register new mirror
      # classes. If used within a module, each class that includes
      # that specific module is registered upon inclusion.
      #
      # @param [Module] The class or module to register
      #
      # @return [Mirror] returns self
      def register_mirror(klass)
        @@mirrors.unshift klass
        self
      end

      # @param [Object] the object to reflect upon
      #
      # @return [Mirror, NilClass] the class to instantiate as mirror,
      #   using #new, or nil, if non is known
      def mirror_class(obj)
        self if reflects?(obj)
      end

      # Only define this once, and always get the ClassMethods from
      # the current module. When [Mirror] is included in another
      # module, this will enable that module to also define ClassMethods
      # to mix in when included. Additionally, if [Mirror] had registered
      # itself for matching specific objects, this registration is forwarded
      # to the class.
      def included(base)
        base.extend(const_get("ClassMethods")) if const_defined?("ClassMethods")
      end
    end

    extend ClassMethods

    def initialize(obj)
      @subject = obj
    end

    # A generic representation of the object under observation.
    def name
      @subject.inspect
    end

    # The equivalent to #==/#eql? for comparison of mirrors against objects
    def mirrors?(other)
      @subject == other
    end

    # Accessor to the reflected object
    def reflectee
      @subject
    end
  end
end
