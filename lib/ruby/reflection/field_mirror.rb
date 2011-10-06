module Ruby
  class Reflection
    class FieldMirror < Mirror
      include AbstractReflection::FieldMirror
      Field = Struct.new(:object, :name)
      reflect! Field

      def self.mirror_class(field)
        if reflects?(field)
          case
          when field.name.start_with?("@@")
            ClassVariableMirror
          when field.name.start_with?("@")
            InstanceVariableMirror
          else
            ConstantMirror
          end
        end
      end

      def initialize(obj)
        super
        @object = obj.object
        @name = obj.name
      end

      def name
        @name
      end
    end
  end
end

require 'ruby/reflection/field_mirror/class_variable_mirror'
require 'ruby/reflection/field_mirror/instance_variable_mirror'
require 'ruby/reflection/field_mirror/constant_mirror'
