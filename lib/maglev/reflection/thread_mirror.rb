require 'maglev/reflection/core_ext/thread'

module Maglev
  class Reflection
    class ThreadMirror < Ruby::Reflection::ThreadMirror
      reflect! Thread
      StackFrame = Struct.new :method, :index, :thread

      def stack
        @subject.__stack_depth.times.collect do |idx|
          method = Mirror.reflect @subject.__method_at(idx + 1)
          frame = StackFrame.new method, idx + 1, self
          StackFrameMirror.reflect frame
        end
      end

      # Maglev specific
      def thread_report(index)
        @subject.__gsi_debugger_detailed_report_at(index)
      end
    end
  end
end
