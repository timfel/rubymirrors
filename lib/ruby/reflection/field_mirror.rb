module Ruby
  class Reflection
    class FieldMirror < Mirror
      include AbstractReflection::FieldMirror
      Field = Struct.new(:object, :name)
      reflect! Field

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
