module Ruby
  class Reflection
    class InstanceVariableMirror < FieldMirror
      def value
        reflection.reflect @object.instance_variable_get(@name)
      end

      def value=(o)
        @object.instance_variable_set(@name, o)
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
