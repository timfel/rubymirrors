require 'ruby/reflection/support/shift_reset'
require 'continuation' unless defined? callcc

module Ruby
  class Reflection
    class ThreadMirror < ObjectMirror
      include AbstractReflection::ThreadMirror
      include ShiftReset
      reflect! Thread
      Frame = Struct.new :method, :index, :file, :line, :thread

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

      def stack
        if bt = @subject.backtrace
          bt.each_with_index.collect do |str, idx|
            file, line, method_spec = str.split(':')
            method_spec =~ /\`([^']+)'/
            method = $1
            frame = Frame.new method, idx, file, line, self
            reflection.reflect frame
          end
        else
          []
        end
      end

      def return_value
        return nil if @subject.alive?
        @subject.value
      end
    end
  end
end
