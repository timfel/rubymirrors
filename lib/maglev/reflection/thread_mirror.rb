require 'maglev/reflection/core_ext/thread'
require 'maglev/reflection/core_ext/method'
require 'maglev/reflection/core_ext/maglev'
require 'maglev/objectlog'

module Maglev
  class Reflection
    class ThreadMirror < Ruby::Reflection::ThreadMirror
      reflect! Thread
      StackFrame = Struct.new :method, :index, :thread
      ExceptionHandlers = {}

      def self.copy_active_thread
        save_thread("Continuation #{Thread.current}").continuation
      end

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
          Thread.start { @subject.__value(nil) }.run
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

      def shift(block = Proc.new)
        cm = self.method(:reset).__st_gsmeth
        markLevel = nil
        level = 1
        idx = nil
        while aFrame = Thread.__frame_contents_at(level) and idx == nil
          idx = level if aFrame[0] == cm
          level += 1
        end
        raise(RuntimeError, "no enclosing #reset") if idx.nil?
        # from my caller to the reset caller
        partial_cc = Thread.__partialContinuationFromLevel_to(2, idx + 1)
        res = block.call(reflection.reflect(partial_cc))

        # Now, return execution to the reset: call and replace the
        # top-of-stack with the result of the block

        # from reset to reset caller
        cc = Thread.__partialContinuationFromLevel_to(idx - 1, idx + 1)
        Thread.__installPartialContinuation_atLevel_value(cc, idx + 1, res)
      end

      def reset(block = Proc.new)
        (proc { block.call }).call
      end

      def call(arg)
        if @subject.__is_partial_continuation
          Thread.__installPartialContinuation_atLevel_value(@subject, 1, arg)
        end
      end
    end
  end
end
