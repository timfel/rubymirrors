require 'reflection'
require 'ruby/reflection/mirror'

module Ruby
  class Reflection < ::Reflection
    def self.codebase
      nil.class
    end

    def self.reflect(ignored)
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

    def threads
      instances_of(Thread)
    end

    private
    def mirrors(list)
      list.collect {|each| Mirror.reflect(each) }
    end
  end
end

