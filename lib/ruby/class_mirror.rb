class Reflection
  class ClassMirror < Mirror
    def name
      subject.name
    end
    
    def instance_variables
      []
    end

    def class_variables
      subject.class_variables
    end

    def class_instance_variables
      singleton_class.instance_variables
    end
    
    def source_files
      method_objects = subject.instance_methods.collect do |name|
        subject.instance_method(name)
      end
      method_objects.collect(&:source_location).collect(&:first).uniq
    end

    def singleton_class
      Reflection.reflect_class(subject.singleton_class)
    end

    def nesting
      subject.class_eval { Module.nesting }
    end

    def mixins
      subject.ancestors.reject {|m| m.is_a? Class }
    end

    def superclass
      subject.superclass
    end

    def subclasses
      ObjectSpace.each_object(Class).select {|a| a.superclass == Object }
    end

    def ancestors
      subject.ancestors.collect {|m| Reflection.reflect_class(m) }
    end
  end
end
