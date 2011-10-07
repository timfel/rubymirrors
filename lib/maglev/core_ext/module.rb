RubyNameSpace = __resolve_smalltalk_global(:RubyNameSpace)
class RubyNameSpace
  primitive 'parent', 'parent'
  primitive 'my_class', 'myClass'
  primitive 'keys', 'keys'
  primitive '[]', 'at:'
end

class Module
  primitive '__transient_namespace', 'transientNameSpace:'
  primitive 'singleton_class?', 'isRubySingletonClass'
  primitive '__the_non_meta_class', 'theNonMetaClass'
  primitive '__inst_var_names', 'instVarNames'
  primitive '__inst_var_at', 'instVarAt:'
  primitive '__inst_var_at_put', 'instVarAt:Put:'
  primitive '__compile_method_category_environment_id', 'compileMethod:category:environmentId:'
end
