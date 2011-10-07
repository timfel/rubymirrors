require 'maglev/core_ext/module'

module Ruby
  class Reflection
    class ClassMirror < ObjectMirror
      include AbstractReflection::ClassMirror
      reflect! Module

      # The namespace (lexical scope) in which the Module was defined
      def namespace
        if ts = __transient_namespace(1)
          return ts.parent
        end
      end

      def singleton_instance
        raise TypeError, "not a singleton class" unless self.singleton_class?
        if self.inspect =~ /^#<Class:.*>$/

        else
          raise NotImplementedError, "not implemented yet"
        end
      end

      def compile_method(source, selector = nil)
        meth_dict = instance_methods(false) + methods(false)
        if selector || (md = /^\s*def\s+(?:self\.)?([^;\( \n]+)/.match(source))
          selector = selector || md[1]
          begin
            method(selector).source!(source, true)
          rescue NameError, TypeError
            class_eval(source)
          end
        else
          class_eval(source)
        end
        new_meth_dict = instance_methods(false) + methods(false)
        new_method_selector = if new_meth_dict > meth_dict
          (new_meth_dict - meth_dict).first
        else
          selector
        end
        method(new_method_selector) if new_method_selector
      end

      # Traverse the Ruby namespace hierarchy and execute block for all classes
      # and modules.  Returns an IdentitySet of all classes and modules found.
      # Skips autoloads (i.e., does not trigger them and does not yield them to
      # the block).
      #
      # @param [Module] klass The Class or Module object to start traversal.
      #         Default is Object.
      #
      # @param [IdentitySet] rg The recursion guard used to prevent infinite
      #         loops; also used as return value.
      #
      # @return [IdentitySet] An IdentitySet of all the Classes and Modules
      #         registered in the Ruby namespace
      #
      def each_module(rg=IdentitySet.new, &block)
        unless rg.include?(self)
          rg.add self
          yield(self) if block
          self.constants.each do |c|
            unless self.autoload?(c)
              begin
                obj = self.const_get(c)
                obj.each_module(rg, &block) if Module === obj
              rescue Exception
                next
              end
            end
          end
        end
        rg
      end

      # Return an object named in the Ruby namespace.
      #
      # @param [String] name The name of the object. E.g., "Object",
      #         "Errno::EACCES", "Foo::Bar::Baz".
      #
      # @return [Object] the named object.
      #
      # @raise [NameError] if the name can't be found
      def find_in_namespace(name)
        name.split('::').inject(self) do |parent, name|
          obj = parent.const_get name
        end
      end

      def instance_variables
        @subject.__inst_var_names do ||
        end
      end
      
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
