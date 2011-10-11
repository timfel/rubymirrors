require 'maglev/reflection/core_ext/thread'

module Maglev
  class Reflection
    class ThreadMirror < Ruby::Reflection::ThreadMirror
      reflect! Thread
      
      def stack
        self.__stack_depth.times.collect do |idx|
          StackFrameMirror.reflect(self.__method_at(idx + 1), idx + 1, self)
        end
      end
    end
  end
end
