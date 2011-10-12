require 'maglev/reflection/core_ext/thread'

module Maglev
  class Reflection
    class ThreadMirror < Ruby::Reflection::ThreadMirror
      reflect! Thread

      StackFrame = Struct.new :method, :index, :thread

      def stack
        self.__stack_depth.times.collect do |idx|
          frame = StackFrame.new(self.__method_at(idx + 1), idx + 1, self)
          StackFrameMirror.reflect(frame)
        end
      end
    end
  end
end
