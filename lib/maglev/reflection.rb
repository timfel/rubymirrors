require 'ruby/reflection'

module Maglev
  class Reflection < Ruby::Reflection
    def modules
      mirror_modules_satisfying {|m| Module === m && !(Class === m) }
    end

    def classes
      mirror_modules_satisfying {|m| Class === m }
    end

    private
    def mirror_modules_satisfying
      modules = Mirror.reflect(Object).each_module
      modules = modules.select {|m| yield m }
      modules.collect {|m| Mirror.reflect m }
    end
  end
end

require 'maglev/reflection/mirror'
require 'maglev/reflection/object_mirror'
require 'maglev/reflection/field_mirror'
require 'maglev/reflection/thread_mirror'
require 'maglev/reflection/stack_frame_mirror'
require 'maglev/reflection/class_mirror'
require 'maglev/reflection/method_mirror'
