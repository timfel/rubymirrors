module Maglev
  class Reflection
    class ObjectMirror < Ruby::Reflection::ObjectMirror
      reflect! Object

      private
      def field_mirrors(list, subject = @subject)
        list.collect do |name|
          field_mirror(subject, name)
        end
      end

      def field_mirror(subject, name)
        reflection.reflect FieldMirror::Field.new(subject, name)
      end
    end
  end
end
