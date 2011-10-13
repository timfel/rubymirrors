module Maglev
  ClassOrganizer = __resolve_smalltalk_global(:ClassOrganizer)
  class ClassOrganizer
    # @return [ClassOrganizer] the cached instance or a fresh one
    class_primitive_nobridge 'cached_organizer', 'cachedOrganizer'
    # Clears the cached instance
    class_primitive_nobridge 'clear_cache', 'clearCachedOrganizer'

    primitive 'all_ruby_classes', '_allRubyClasses'
    primitive 'all_ruby_classes_under', '_allRubyClasses:'

    # @return [Array<Class>]
    primitive 'implementors_of', 'rubyImplementorsOf:'
    primitive 'implementors_of_in', 'rubyImplementorsOf:in:'

    # @return [Array<GsNMethod>]
    primitive 'senders_of', 'rubySendersOf:'
    primitive 'senders_of_in', 'rubySendersOf:in:'
  end
end
