module Ruby
  class Reflection
    class ObjectMirror < Mirror
      include AbstractReflection::ObjectMirror
      reflect! (defined?(BasicObject) ? BasicObject : Object)

      def variables
        @subject.instance_variables.collect do |name|
          Mirror.reflect FieldMirror::Field.new(@subject, name)
        end
      end
    end
  end
end
