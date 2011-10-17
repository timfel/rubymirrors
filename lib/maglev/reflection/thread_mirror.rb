require 'maglev/reflection/core_ext/thread'
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

      private
      ##
      # Saves an exception to the ObjectLog.
      # This will abort any pending transaction.
      def self.save_thread(message)
        if Maglev::System.needs_commit
          warn("Saving exception to ObjectLog, discarding transaction")
        end
        Maglev.abort_transaction
        res = DebuggerLogEntry.create_continuation_labeled(message)
        begin
          Maglev.commit_transaction
        rescue Exception => e
          warn "Error trying to save a continuation to the stone: #{e.message}"
        end
        res
      end
    end
  end
end
