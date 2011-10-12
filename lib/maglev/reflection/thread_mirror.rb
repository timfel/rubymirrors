require 'maglev/reflection/core_ext/thread'

module Maglev
  class Reflection
    class ThreadMirror < Ruby::Reflection::ThreadMirror
      reflect! Thread
      StackFrame = Struct.new :method, :index, :thread

      def stack
        @subject.__stack_depth.times.collect do |idx|
          rmeth = GsNMethodWrapper.new(@subject.__method_at(idx + 1))
          method = Mirror.reflect rmeth
          frame = StackFrame.new method, idx + 1, self
          StackFrameMirror.reflect frame
        end
      end
    end
  end
end
