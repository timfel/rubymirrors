module Ruby
  class Reflection
    class ConstantMirror < FieldMirror
      def value
        if path = @object.autoload?(@name)
          unless $LOADED_FEATURES.include?(path) ||
              $LOADED_FEATURES.include?(File.expand_path(path))
            # Do not trigger autoload
            return nil
          end
        end
        Mirror.reflect @object.const_get(@name)
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
        @object.send(:remove_const, @name)
      end
    end
  end
end
