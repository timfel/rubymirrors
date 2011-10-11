require 'maglev/reflection/core_ext/method'

module Maglev
  class Reflection
    class MethodMirror < Mirror
      include AbstractReflection::MethodMirror
      reflect! UnboundMethod

      def file
        (@subject.source_location || [])[0]
      end

      def file=(string)
        raise CapabilitiesExceeded unless regular_method?
        reload_after do
          defining_class.class_eval(source, string, line)
        end
      end

      def line
        (@subject.source_location || [])[1]
      end

      def line=(num)
        raise CapabilitiesExceeded unless regular_method?
        reload_after do
          defining_class.class_eval(source, file, num - 1)
        end
      end

      def source
        gsmeth.__source_string
      end

      def source=(str)
        raise CapabilitiesExceeded unless regular_method?
        reload_after do
          if file.nil? && line.nil? # Smalltalk method
            defining_class.__compile_method_category_environment_id(str, '*maglev-dynamic-compile-unclassified', 1)
          else # Ruby method
            defining_class.class_eval(str, file, line)
          end
        end
      end

      def selector
        @subject.name.to_s
      end

      def defining_class
        gsmeth.__in_class
      end

      def arguments
        gsmeth.__args_and_temps.to_a[0...gsmeth.__num_args].collect(&:to_s)
      end

      def block_argument
        return nil unless gsmeth.__selector.to_s[-1] == ?&
        arguments.last
      end

      def optional_arguments
        opt_arg_offset = gsmeth.__ruby_opt_args_bits.to_s(2).reverse.index(?1)
        argsize = gsmeth.__num_args
        unless opt_arg_offset
          if block_argument && splat_argument
            opt_arg_offset = argsize - 2
          elsif block_argument || splat_argument
            opt_arg_offset = argsize - 1
          else
            opt_arg_offset = -2
          end
        end
        arguments[opt_arg_offset..-1]
      end

      def required_arguments
        arguments - optional_arguments
      end

      def splat_argument
        return nil unless gsmeth.__selector.to_s[-2] == ?*
        block_argument ? arguments[-2] : arguments[-1]
      end

      def step_offsets
        gsmeth.__source_offsets
      end

      def send_offsets
        offs = gsmeth.__source_offsets_of_sends.to_a
        offs = offs.each_slice(2).collect do |offset, selector|
          [prefix_if_ruby_selector(selector), offset]
        end
        Hash[*offs.flatten]
      end

      def bytecodes
        gsmeth.__ip_steps.to_a.collect {|ip| gsmeth.__opcode_info_at(ip) }
      end

      def delete
        raise CapabilitiesExceeded unless regular_method?
        gsmeth.__in_class.remove_method(selector)
      end

      private
      def gsmeth
        @subject.__st_gsmeth
      end

      # Removes the Ruby suffix from the GsNMethod selector
      def prefix_if_ruby_selector(sym)
        selector = sym.to_s
        selector[0...selector.rindex(?#)]
      end

      def regular_method?
        not (gsmeth.__is_method_for_block || gsmeth.__in_class.nil?)
      end

      def reload_after(&block)
        cls = defining_class
        sel = selector.to_sym
        yield
        @subject = cls.instance_method(sel)
      end
    end
  end
end
