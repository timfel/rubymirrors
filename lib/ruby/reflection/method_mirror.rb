begin
  require 'method_source'
rescue LoadError
end
begin
  require 'ruby_parser' unless defined? RubyParser
rescue LoadError
end

module Ruby
  class Reflection
    class MethodMirror < Mirror
      include AbstractReflection::MethodMirror
      reflect! Method, UnboundMethod

      def file
        source_location.first
      end

      def file=(name)
        defining_class.reflectee.class_eval(source, name, line)
        @subject = defining_class.method(selector)
      end

      def line
        source_location.last - 1
      end

      def line=(num)
        defining_class.reflectee.class_eval(source, file, num)
        @subject = defining_class.method(selector)
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
      rescue => e
        e.message
      end

      def source=(str)
        src = try_send(:source)
        raise "cannot write to source location" unless file and line and File.writable?(file)

        f = File.read(file).lines.to_a
        srclen = src.lines.to_a.size
        prefix = f[0...line].join
        method_src = f[line...line + srclen].join
        postfix = f[line + srclen..-1].join
        raise "source differs from runtime" unless method_src.strip == src.strip

        File.open(file, 'w') {|f| f << prefix << str << postfix }
        defining_class.reflectee.class_eval(str, file, line)
      rescue Exception => e
        raise CapabilitiesExceeded, e.message
      end

      def step_offsets
        [1, *send_offsets.values]
      end

      def send_offsets
        sexp = RubyParser.new.process(source).flatten
        sends = sexp.each_with_index.map {|e,i| sexp[i-1] if e == :arglist }
        sends = sends.compact.collect(&:to_s)

        offsets = [0]
        sends.each do |name|
          next_offset = source[offsets.last..-1] =~ /#{Regexp.escape(name)}/
          break unless next_offset
          offsets << next_offset
        end
        offsets.shift
        Hash[*sends.zip(offsets).flatten]
      rescue Exception
        return {}
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
