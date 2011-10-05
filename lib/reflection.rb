class Reflection
  # A marker, raised when trying to run something
  # that the reflective API doesn't support.
  class CapabilitiesExceeded < StandardError; end

  # A mirror has to reflect on something. file mirrors on files or
  # directories, VM mirrors on the running VM or a remote instance and
  # so on...  This method allows you to query what kind of object you
  # need to prepare to use it.
  #
  # @return [Array<Class>, Class] the class(es) that this reflective api can work on
  def self.codebase
    raise NotImplementedError, "#{self.class} should have implemented #codebase"
  end

  # Creates a new instance of a Reflection
  # @param [Object] the codebase to work on, e.g. a file or a VM
  # @return [Reflection] a new reflection object
  def self.reflect(codebase)
    raise NotImplementedError, "#{self.class} should have implemented #reflect"
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
end
