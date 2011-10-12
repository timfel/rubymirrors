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
        locations = @subject.instance_methods(false).collect do |name|
          method = @subject.instance_method(name)
          file   = method.source_location if method.respond_to? :source_location
          file.first if file
        end
        locations.compact.uniq
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
