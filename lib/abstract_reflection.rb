module AbstractReflection
  # A marker, raised when trying to run something
  # that the reflective API doesn't support.
  class CapabilitiesExceeded < StandardError; end

  module ClassMethods
    # A mirror has to reflect on something. file mirrors on files or
    # directories, VM mirrors on the running VM or a remote instance and
    # so on...  This method allows you to query what kind of object you
    # need to prepare to use it.
    #
    # @return [Array<Class>, Class] the class(es) that this reflective api can work on
    def codebase
      raise NotImplementedError, "#{self} should have implemented #codebase"
    end

    # Creates a new instance of a Reflection
    # @param [Object] the codebase to work on, e.g. a file or a VM
    # @return [Reflection] a new reflection object
    def reflect(codebase)
      raise NotImplementedError, "#{self} should have implemented #reflect"
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  # This method can be used to query the system for known modules. It
  # is not guaranteed that all possible modules are returned.
  # 
  # @return [Array<ClassMirror>] a list of class mirrors
  def modules
    raise CapabilitiesExceeded
  end

  # This method can be used to query the system for known classes. It
  # is not guaranteed that all possible classes are returned.
  # 
  # @return [Array<ClassMirror>] a list of class mirrors
  def classes
    raise CapabilitiesExceeded
  end

  # Query the system for objects that are direct instances of the
  # given class.
  # @param [Class]
  # @return [Array<ObjectMirror>] a list of appropriate mirrors for the requested objects
  def instances_of(klass)
    raise CapabilitiesExceeded
  end

  # Ask the system to find the object with the given object id
  # @param [Numeric] object id
  # @return [ObjectMirror, NilClass] the object mirror or nil
  def object_by_id(id)
    raise CapabilitiesExceeded
  end

  # Query the system for implementors of a particular message
  # @param [String] the message name
  # @return [Array<MethodMirror>] the implementing methods
  def implementations_of(message)
    raise CapabilitiesExceeded
  end

  # Query the system for senders of a particular message
  # @param [String] the message name
  # @return [Array<MethodMirror>] the sending methods
  def senders_of(message)
    raise CapabilitiesExceeded
  end

  # Return the currently active threads in the system
  # @return [Array<ThreadMirror>] a list of thread mirrors
  def threads
    raise CapabilitiesExceeded
  end

  # @return [String] the platform the system is running on. usually RUBY_PLATFORM
  def platform
    raise CapabilitiesExceeded
  end

  # @return [String] the used implementation of Ruby
  def engine
    raise CapabilitiesExceeded
  end

  # @return [String] the version string describing the system
  def version
    raise CapabilitiesExceeded
  end

  # Create a mirror for a given object in the system under
  # observation.
  # @param [Object]
  # @return [Mirror]
  def reflect_object(o)
    Mirror.reflect(o)
  end
end

require 'abstract_reflection/mirror'
require 'abstract_reflection/object_mirror'
require 'abstract_reflection/field_mirror'
require 'abstract_reflection/class_mirror'
require 'abstract_reflection/method_mirror'
require 'abstract_reflection/thread_mirror'
require 'abstract_reflection/stack_frame_mirror'
require 'abstract_reflection/gc_mirror'
require 'abstract_reflection/compiler_mirror'
