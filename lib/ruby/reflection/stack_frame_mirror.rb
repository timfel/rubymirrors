module Ruby
  class Reflection
    class StackFrameMirror < Mirror
      include AbstractReflection::StackFrameMirror
      reflect! ThreadMirror::Frame

      attr_reader :name
      attr_reader :method

      def initialize(obj)
        super
        @name = obj.method
        @index = obj.index
        method_obj = Reflection.implementations_of(@name).detect do |m|
          m.source_location == [obj.file, obj.line]
        end
        @method = Mirror.reflect method
        @thread = obj.thread
      end
    end
  end
end
