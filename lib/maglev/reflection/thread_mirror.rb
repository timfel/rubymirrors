require 'maglev/reflection/core_ext/thread'

module Maglev
  class Reflection
    class ThreadMirror < Ruby::Reflection::ThreadMirror
      reflect! Thread
      StackFrame = Struct.new :method, :index, :thread
      ExceptionHandlers = {}

      def stack
        @subject.__stack_depth.times.collect do |idx|
          method = reflection.reflect @subject.__method_at(idx + 1)
          frame = StackFrame.new method, idx + 1, self
          StackFrameMirror.reflect frame, reflection
        end
      end

      # Maglev specific
      def thread_report(index)
        @subject.__gsi_debugger_detailed_report_at(index)
      end

      def run
        if @subject.__is_continuation
          raise RuntimeError, "cannot run a continuation with #run"
        end
        super
      end

      def wakeup
        if @subject.__is_continuation
          raise RuntimeError, "cannot wakeup a continuation with #wakeup"
        end
        super
      end

      def step(symbol = :over)
        case symbol
        when :into
          @subject.__step_over_in_frame(0)
        when :over
          @subject.__step_over_in_frame(1)
        when :through
          raise NotImplementedError, "not implemented yet"
        when Fixnum
          @subject.__step_over_in_frame(symbol)
        end
      end

      def handle_exception(e = Exception, &block)
        ExceptionHandlers[@subject.object_id] ||= []
        ExceptionHandlers[@subject.object_id] << proc do |ex|
          block[ex] if [*e].any? {|ec| ex.is_a? ec }
        end

        Exception.install_debug_block do |ex|
          if handlers = ExceptionHandlers[Thread.current.object_id]
            handlers.each {|h| h[ex] }
          end
        end
      end

      # Maglev specific... for now
      def raw_stack
        stack # Force cache refresh
      end

      def thread_data
        @subject.__client_data
      end

      def compiler_state
        thread_data.first
      end
    end
  end
end
