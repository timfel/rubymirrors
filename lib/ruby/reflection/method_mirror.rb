module Ruby
  class Reflection
    class MethodMirror < Mirror
      include AbstractReflection::MethodMirror
      reflect! Method, UnboundMethod

      def file
        source_location.first
      end

      def line
        source_location.last
      end

      def selector
        @subject.name.to_s
      end
    end
  end
end
