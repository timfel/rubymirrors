module Maglev
  class Reflection
    class StackFrameMirror < ObjectMirror
      include AbstractReflection::StackFrameMirror
      reflect! ThreadMirror::StackFrame
    end
  end
end
