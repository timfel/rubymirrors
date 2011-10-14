module Maglev
  class Reflection
    class StackFrameMirror < ObjectMirror
      include AbstractReflection::StackFrameMirror
      reflect! ThreadMirror::StackFrame

      attr_reader :method

      def initialize(obj)
        super
        @method = obj.method
        @index = obj.index
        @thread = obj.thread
      end

      def name
        @method.selector
      end

      def receiver
        reflection.reflect detailed_report[1]
      end

      def self
        reflection.reflect detailed_report[2]
      end

      def selector
        reflection.reflect detailed_report[3].to_s
      end

      def arguments
        args_and_temps(0, num_args - 1)
      end

      def locals
        args_and_temps(num_args, -1)
      end

      def step_offset
        detailed_report[4]
      end

      def source_offset
        detailed_report[5][step_offset - 1]
      end

      def variable_context
        raise NotImplementedError, "TODO"
        @thread.reflectee.__frame_contents_at(@index)[3]
      end

      def restart
        @thread.reflectee.__trim_stack_to_level(@index)
        true
      end

      def pop
        @thread.reflectee.__trim_stack_to_level(@index + 1)
        true
      end

      def step(*args)
        @thread.step(*args)
        true
      end

      def inspect
        "#<#{self.class}: #{@index}: #{@method.defining_class}##{@method.name}>"
      end

      private
      def detailed_report
        @report ||= @thread.thread_report(@index)
      end

      def num_args
        @method.arguments.size
      end

      def args_and_temps(from, to)
        names = detailed_report[6][from..to].collect(&:to_s)
        values = detailed_report[7][from..to].collect(&:to_s)
        (values.size - names.size).times {|i| names << ".temp#{i+1}"}
        values.map! {|v| reflection.reflect v }
        FrameHash[names.zip(values)].tap {|o| o.frame = self }
      end

      class FrameHash < Hash
        attr_writer :frame

        def []=(key, value)
          super
          if @frame
            @frame.thread.reflectee.__frame_at_temp_named_put(@frame.index,
                                                              key.to_s,
                                                              value)
          end
        end
      end

    end
  end
end
