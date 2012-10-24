require 'maglev/orderedcollection'

class Module
  RubyNameSpace = __resolve_smalltalk_global(:RubyNameSpace)
  RubyTransientNameSpace = __resolve_smalltalk_global(:RubyTransientNameSpace)

  class RubyNameSpace
    primitive 'parent', 'parent'
    primitive 'my_class', 'myClass'
    primitive 'keys', 'keys'
    primitive 'values', 'values'
    primitive '[]', 'at:'
  end

  class RubyTransientNameSpace < RubyNameSpace
    primitive 'parent', 'parent'
    primitive 'persistent_copy', 'persistentCopy'

    def keys
      super + (persistent_copy ? persistent_copy.keys : [])
    end

    def values
      super.to_a + (persistent_copy ? persistent_copy.values.to_a : [])
    end

    def [](other)
      super || (persistent_copy ? persistent_copy[other] : nil)
    rescue Exception
      nil
    end
  end

  primitive '__transient_namespace', 'transientNameSpace:'
  primitive 'singleton_class?', 'isRubySingletonClass'
  primitive '__the_non_meta_class', 'theNonMetaClass'
  primitive '__inst_var_names', 'instVarNames'
  primitive '__compile_method_category_environment_id', 'compileMethod:category:environmentId:'
  primitive '__compile_method_category_environment_id', 'compileMethod:category:environmentId:'
end
