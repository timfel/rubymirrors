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
        reflection.reflect @subject.singleton_class
      end

      def singleton_class?
        self.name =~ /^\#<Class:.*>$/
      end

      def mixins
        mirrors @subject.ancestors.reject {|m| m.is_a? Class }
      end

      def superclass
        reflection.reflect @subject.superclass
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

      def constant(str)
        path = str.to_s.split("::")
        c = path[0..-2].inject(@subject) {|klass,str| klass.const_get(str) }
        field_mirror (c || @subject), path.last
      rescue NameError => e
        p e
        nil
      end

      def nesting
        ary = []
        @subject.name.split("::").inject(Object) do |klass,str|
          ary << klass.const_get(str)
          ary.last
        end
        ary.reverse
      rescue NameError => e
        [@subject]
      end

      def nested_classes
        nc = @subject.constants.collect do |c|
          # do not trigger autoloads
          if @subject.const_defined?(c) and not @subject.autoload?(c)
            @subject.const_get(c)
          end
        end.compact.select {|c| Module === c }
        mirrors nc
      end

      def methods
        @subject.instance_methods(false).collect(&:to_s)
      end

      def method(name)
        reflection.reflect @subject.instance_method(name)
      end
    end
  end
end
