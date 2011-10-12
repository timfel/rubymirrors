module Ruby
  class Reflection
    class FieldMirror < Mirror
      include AbstractReflection::FieldMirror
      Field = Struct.new(:object, :name)
      reflect! Field

      def self.mirror_class(field)
        return unless reflects? field
        case field.name.to_s
        when /^@@/ then ClassVariableMirror
        when /^@/  then InstanceVariableMirror
        else            ConstantMirror
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
