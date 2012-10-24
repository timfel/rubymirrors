require 'maglev/reflection/core_ext/module'
require 'maglev/reflection/core_ext/class'

module Maglev
  class Reflection
    class FixedInstanceVariableMirror < FieldMirror
      def initialize(obj)
        super
        fixed_ivs = @object.__inst_var_names.to_a
        @index = index(@name)
      end

      def public?
        false
      end

      def protected?
        false
      end

      def private?
        true
      end
    end
  end
end
