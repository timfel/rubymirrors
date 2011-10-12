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
    end
  end
end
