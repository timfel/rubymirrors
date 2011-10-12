module Ruby
  class Reflection
    class ConstantMirror < FieldMirror
      def value
        @object.const_get(@name)
      end

      def value=(o)
        @object.const_set(@name, o)
      end

      def public?
        true
      end

      def protected?
        false
      end

      def private?
        false
      end

      def delete
        @object.remove_const(@name)
      end
    end
  end
end
