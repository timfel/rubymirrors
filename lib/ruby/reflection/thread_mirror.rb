module Ruby
  class Reflection
    class ThreadMirror < ObjectMirror
      include AbstractReflection::ThreadMirror
      reflect! Thread

      def status
        s = @subject.status
        if s.respond_to? :to_str
          s.to_str
        elsif s.nil?
          "aborted"
        else
          "dead"
        end
      end

      def run
        @subject.run
      end

      def return_value
        return nil if @subject.alive?
        @subject.value
      end
    end
  end
end
