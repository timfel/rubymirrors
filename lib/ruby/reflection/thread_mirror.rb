module Ruby
  class Reflection
    class ThreadMirror < ObjectMirror
      include AbstractReflection::ThreadMirror
      reflect! Thread
    end
  end
end
