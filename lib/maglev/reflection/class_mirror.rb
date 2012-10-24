require 'maglev/reflection/core_ext/module'
require 'maglev/reflection/core_ext/class'

module Maglev
  class Reflection
    class ClassMirror < ObjectMirror
      include AbstractReflection::ClassMirror
      reflect! Module

      def singleton_instance
        raise TypeError, "not a singleton class" unless self.singleton_class?
        if self.inspect =~ /^#<Class:.*>$/

        else
          raise NotImplementedError, "not implemented yet"
        end
      end

      def singleton_class
        reflection.reflect @subject.singleton_class
      end

      def singleton_class?
        self.name =~ /^\#<Class:.*>$/
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

      def instance_variables
        if (fixed_ivs = @subject.__inst_var_names).empty?
          raise AbstractReflection::CapabilitiesExceeded
        else
          field_mirrors fixed_ivs
        end
      end

      def class_variables
        field_mirrors @subject.class_variables
      end

      def class_instance_variables
        field_mirrors @subject.instance_variables
      end

      def nested_classes
        constants.collect(&:value).select {|c| ClassMirror === c }
      end

      def source_files
        method_objects = @subject.instance_methods(false).collect do |name|
          @subject.instance_method(name)
        end
        method_objects += @subject.methods(false).collect do |name|
          @subject.method(name)
        end
        method_objects.collect(&:source_location).collect(&:first).uniq
      end

      def mixins
        mirrors @subject.ancestors.reject {|m| m.is_a? Class }
      end

      def superclass
        self.class.new @subject.superclass
      end

      def subclasses
        ary = []
        each_module do |m|
          ary << m if m.superclass && m.superclass.mirrors?(@subject)
        end
        ary
      end

      def ancestors
        mirrors @subject.ancestors
      end

      def constant(str)
        path = str.to_s.split("::")
        c = path[0..-2].inject(@subject) {|klass,str| klass.const_get(str) }
        field_mirror c, path.last
      rescue NameError
        nil
      end

      def constants
        field_mirrors (@subject.constants - @subject.instance_variables)
      end

      def method(name)
        reflection.reflect @subject.instance_method(name.to_s)
      end

      def methods
        @subject.instance_methods(false)
      end

      def nesting
        ary = [@subject]
        while (ns = ary.last.__transient_namespace(1)) &&
              (par = ns.parent) &&
              (nxt = par.my_class)
          break if nxt.nil? || nxt == Object
          ary << nxt
        end
        ary
      end

      # Maglev specific, not public reflection API.
      #
      # Traverse the Ruby namespace hierarchy and execute block for
      # all classes and modules.  Returns an IdentitySet of all
      # classes and modules found.  Skips autoloads (i.e., does not
      # trigger them and does not yield them to the block).
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
      def each_module(from=Object, rg=IdentitySet.new, &block)
        unless rg.include?(from)
          rg.add from
          yield reflection.reflect(from) if block
          if ns = from.__transient_namespace(1)
            ns.values.each {|c| each_module(c, rg, &block) if Module === c }
          end
        end
        rg
      end

    end
  end
end
