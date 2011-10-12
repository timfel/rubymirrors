module Ruby
  class Reflection
    class ClassVariableMirror < FieldMirror
      def value
        @object.class_variable_get(@name)
      end

      def value=(o)
        @object.class_variable_set(@name, o)
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
