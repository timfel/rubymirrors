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

      def defining_class
        try_send(:owner)
      end

      def delete
        try_send(:owner).send(:remove_method, @subject.name)
      end
    end
  end
end
