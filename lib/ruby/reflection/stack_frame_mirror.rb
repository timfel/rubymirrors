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
        @method = find_method_for(obj.file, obj.line)
        @thread = obj.thread
      end

      def step_offset
        if next_frame = @thread.stack[@index - 1]
          s = @method.send_offsets[next_frame.name]
        end
        s || raise(CapabilitiesExceeded)
      end

      private
      def find_method_for(file, line)
        # Find all methods that are in the same file and start before
        # or on the current line of execution
        possible_methods = reflection.implementations_of(@name).select do |m|
          f, l = m.send(:source_location)
          f == file && l.to_i <= line.to_i
        end

        # Sort by source location. The last method will be the method
        # that starts closest to the current line of execution. This
        # should (for most purposes) be the method we're looking for
        possible_methods.sort_by {|m| m.send(:source_location).last }.last
      end
    end
  end
end
