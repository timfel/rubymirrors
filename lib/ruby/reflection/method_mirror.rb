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

      def splat_argument
        args(:rest).first
      end

      def optional_arguments
        args(:opt)
      end

      def required_arguments
        args(:req)
      end

      def arguments
        try_send(:parameters).map { |t,a| a.to_s }
      end

      private

      def try_send(method)
        raise CapabilitiesExceeded unless @subject.respond_to? method
        @subject.send(method)
      end

      def args(type)
        args = []
        try_send(:parameters).select { |t,n| args << n.to_s if t == type }
        args
      end

      def source_location
        try_send(:source_location) or raise(CapabilitiesExceeded)
      end
    end
  end
end
