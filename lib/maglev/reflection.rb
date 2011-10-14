require 'ruby/reflection'
require 'maglev/reflection/core_ext/class_organizer'

module Maglev
  class Reflection < Ruby::Reflection
    def modules
      mirror_modules_satisfying {|m| Module === m && !(Class === m) }
    end

    def classes
      mirror_modules_satisfying {|m| Class === m }
    end

    def implementations_of(str)
      if sym = Symbol.__existing_symbol(str.to_s)
        class_list = ClassOrganizer.cached_organizer.implementors_of sym
        class_list.collect {|cls| reflection.reflect(cls).method sym }
      else
        []
      end
    end

    def senders_of(str)
      if sym = Symbol.__existing_symbol(str.to_s)
        meth_list = ClassOrganizer.cached_organizer.senders_of sym
        meth_list.collect do |m|
          reflection.reflect(m.__in_class).method m.__name
        end
      else
        []
      end
    end

    private
    def mirror_modules_satisfying
      modules = reflection.reflect(Object).each_module
      modules = modules.select {|m| yield m }
      modules.collect {|m| reflection.reflect m }
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
