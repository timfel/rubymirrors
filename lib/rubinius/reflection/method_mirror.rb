require "rbconfig"

module Rubinius
  class Reflection < Ruby::Reflection
    class MethodMirror < Ruby::Reflection::MethodMirror
      reflect! Method, UnboundMethod
      RubiniusPrefix = RbConfig::CONFIG["prefix"]

      alias super_file file
      def file
        if kernel_method?
          return File.join(RubiniusPrefix, super)
        else
          return super
        end
      end

      def source
        if kernel_method?
          MethodSource.source_helper([file, line + 1])
        else
          super
        end
      end

      private
      def kernel_method?
        super_file.start_with? "kernel"
      end
    end
  end
end
