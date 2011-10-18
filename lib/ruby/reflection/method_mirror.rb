begin
  require 'method_source'
rescue LoadError
  # Only for MRI
end

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
        reflection.reflect try_send(:owner)
      end

      def delete
        try_send(:owner).send(:remove_method, @subject.name)
      end

      def block_argument
        args(:block).first
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

      def protected?
        visibility? :protected
      end

      def public?
        visibility? :public
      end

      def private?
        visibility? :private
      end

      def source
        try_send(:source) or raise(CapabilitiesExceeded)
      end

      def step_offsets
        charcount = [1]
        source.split(".").collect {|str| charcount << (charcount.last + str.size) }
        charcount
      end

      def send_offsets
        offsets = step_offsets
        offsets[1..-2]
      end

      private

      def visibility?(type)
        list = try_send(:owner).send("#{type}_instance_methods")
        list.any? { |m| m.to_s == selector }
      end

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
