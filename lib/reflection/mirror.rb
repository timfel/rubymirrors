# The basic mirror class. It is the most generic mirror and can
# reflect on any object. It is also the factory to use for creating
# new mirrors on any kind of object. Its #reflect class method will
# return an appropriate mirror for a given object, provided one has
# been registered. The [Mirror] class itself is registered as the
# fallback case for any kind of object.
class Reflection::Mirror
  @@mirrors = [[(defined?(BasicObject) ? BasicObject : Object), self]]

  # Reflect on the passed object. This is the default factory for
  # creating new mirrors, and it will try and find the appropriate
  # mirror from the list of registered mirrors.
  #
  # @param [Object] the object to reflect upon. This need not be the
  #   actual object represented - it can itself be just a
  #   representation.  It is really up to the mirror to decide what to
  #   do with it
  def self.reflect(obj)
    target_mirror = @@mirrors.detect {|m, k| m === obj }.last
    target_mirror.new(obj)
  end

  # Some objects may be more useful with a specialized kind of
  # mirror. This method can be used to register new mirror classes for
  # specific kinds of objects
  #
  # @param [Object] sth that responds true on #=== if it wants to handle
  #   an object
  # @return [ObjectMirror] returns self, for chaining
  def self.register_mirror(matcher, klass)
    @@mirrors.unshift(matcher, klass)
  end

  def initialize(obj)
    @subject = obj
  end

  def name
    @subject.inspect
  end
end
