module Ruby
  class Reflection
    class ClassMirror < ObjectMirror
      include AbstractReflection::ClassMirror
      reflect! Module

      def class_variables
        field_mirrors @subject.class_variables
      end

      def class_instance_variables
        field_mirrors @subject.instance_variables
      end

      def source_files
        method_objects = @subject.instance_methods.collect do |name|
          @subject.instance_method(name)
        end
        method_objects.collect(&:source_location).collect(&:first).uniq
      end

      def singleton_class
        Mirror.reflect_object @subject.singleton_class
      end

      def mixins
        mirrors @subject.ancestors.reject {|m| m.is_a? Class }
      end

      def superclass
        Mirror.reflect @subject.superclass
      end

      def subclasses
        l = ObjectSpace.each_object(Class).select {|a| a.superclass == @subject }
        mirrors l
      end

      def ancestors
        mirrors @subject.ancestors
      end

      def constants
        field_mirrors @subject.constants
      end
    end
  end
end
