require 'abstract_reflection'
require 'ruby/reflection/mirror'
require 'ruby/reflection/object_mirror'
require 'ruby/reflection/field_mirror'
require 'ruby/reflection/thread_mirror'
require 'ruby/reflection/class_mirror'
require 'ruby/reflection/method_mirror'

module Ruby
  class Reflection
    include AbstractReflection

    def self.codebase
      nil.class
    end

    def self.reflect(ignored = nil)
      self.new
    end

    def modules
      instances_of(Module)
    end

    def classes
      instances_of(Class)
    end

    def instances_of(klass)
      mirrors ObjectSpace.each_object(klass).select {|obj| obj.class == klass }
    end

    def object_by_id(id)
      if obj = ObjectSpace._id2ref(id)
        Mirror.reflect obj
      else
        nil
      end
    end

    def threads
      instances_of(Thread)
    end

    def platform
      Object::RUBY_PLATFORM
    end

    def engine
      Object::RUBY_ENGINE
    end

    def version
      Object.const_get("#{engine.upcase}_VERSION")
    end

    def implementations_of(str)
      mirrors methods.select {|m| m.name.to_s == str.to_s }
    end

    private
    def methods
      ObjectSpace.each_object(Module).collect do |m|
        ims = m.instance_methods(false).collect {|s| m.instance_method(s) }
        cms = m.methods(false).collect {|s| m.method(s) }
        ims + cms
      end.flatten
    end

    def mirrors(list)
      list.collect {|each| Mirror.reflect(each) }
    end
  end
end
