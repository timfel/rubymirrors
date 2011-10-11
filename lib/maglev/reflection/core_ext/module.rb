class Module
  RubyNameSpace = __resolve_smalltalk_global(:RubyNameSpace)
  RubyNameSpace.primitive 'parent', 'parent'
  RubyNameSpace.primitive 'my_class', 'myClass'
  RubyNameSpace.primitive 'keys', 'keys'
  RubyNameSpace.primitive '[]', 'at:'

  primitive '__transient_namespace', 'transientNameSpace:'
  primitive 'singleton_class?', 'isRubySingletonClass'
  primitive '__the_non_meta_class', 'theNonMetaClass'
  primitive '__inst_var_names', 'instVarNames'
  primitive '__compile_method_category_environment_id', 'compileMethod:category:environmentId:'
  primitive '__compile_method_category_environment_id', 'compileMethod:category:environmentId:'
  primitive '__subclasses', 'subclasses'
end
