module Maglev
  class Reflection
    class StackFrameMirror < ObjectMirror
      include AbstractReflection::StackFrameMirror
      reflect! ThreadMirror::StackFrame

      def initialize(obj)
        super
        @method = obj.method
        @index = obj.index
        @thread = obj.thread
      end

      def name
        @method.selector
      end

      def step_offset
        detailed_report[4]
      end

      private
      def detailed_report
        @report ||= @thread.thread_report(@index)
      end
    end
  end
end
