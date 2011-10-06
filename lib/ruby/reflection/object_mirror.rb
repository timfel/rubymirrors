module Ruby
  class Reflection
    class ObjectMirror < Mirror
      include AbstractReflection::ObjectMirror
      reflect! (defined?(BasicObject) ? BasicObject : Object)

      def variables
        field_mirrors @subject.instance_variables
      end

      private
      def field_mirrors(list, subject = @subject)
        list.collect do |name|
          Mirror.reflect FieldMirror::Field.new(subject, name)
        end
      end
    end
  end
end
