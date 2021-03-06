require 'maglev/objectlog'

class Thread
  VariableContext = __resolve_smalltalk_global(:VariableContext)
  VariableContext.primitive '[]', 'at:'
  VariableContext.primitive '[]=', 'at:put:'
  VariableContext.primitive 'size', 'size'

  # => GsNMethod
  primitive '__method_at', 'methodAt:'
  # => Fixnum
  primitive '__stack_depth', 'stackDepth'
  # Remove all frames above [Fixnum]
  primitive '__trim_stack_to_level', '_trimStackToLevel:'
  # Change temporary at level to value
  primitive '__frame_at_temp_at_put', '_frameAt:tempAt:put:'
  primitive '__frame_at_offset_of_temp_named', '_frameAt:offsetOfTempNamed:'
  # => Array
  #    with:
  #  1  gsMethod
  #  2  self
  #  4  selector
  #  5  quickStepPoint (offset into sourceOffsets)
  #  6  sourceOffsets (the points where each step would be at)
  #  7  argAndTempNames
  #  8  argAndTempValues (maybe smaller or larger than argAndTempNames)
  #  9  sourceString
  #  10 ipOffset
  #  11 markerOrException
  primitive '__gsi_debugger_detailed_report_at', '_gsiDebuggerDetailedReportAt:'
  # Stepping
  primitive '__step_over_in_frame', '_stepOverInFrame:'
  # Persistence conversions
  primitive 'convert_to_persistable_state', "convertToPersistableState"
  primitive 'convert_to_runnable_state', 'convertToRunnableState'
  primitive '__ar_stack', 'arStack'
  primitive '__client_data', 'clientData'
  #  Private.  Returns an Array describing the specified level in the receiver.
  #  aLevel == 1 is top of stack.  If aLevel is less than 1 or greater than
  #  stackDepth, returns nil.
  #  The result Array contains:
  #  offset item
  #  -----  -----
  #    0    gsMethod
  #    1    ipOffset
  #    2    frameOffset (zero-based)
  #    3    varContext
  #    4    saveProtectedMode
  #    5    markerOrException
  #    6    nil (not used)
  #    7    self (possibly nil in a ComplexBlock)
  #    8    argAndTempNames (an Array of Symbols or Strings)
  #    9    receiver
  #   10    arguments and temps, if any
  primitive '__frame_contents_at', '_frameContentsAt:'
  class_primitive '__frame_contents_at', '_frameContentsAt:'
  primitive '__run' , 'rubyRun'
  primitive '__wakeup', 'rubyResume'
  primitive '__value', 'value:'
  primitive '_report', '_reportOfSize:'
  primitive '__is_continuation', 'isContinuation'
  primitive '__is_partial_continuation', 'isPartialContinuation'

  class_primitive '__installPartialContinuation_atLevel_value', 'installPartialContinuation:atLevel:value:'
  class_primitive '__partialContinuationFromLevel_to', 'partialContinuationFromLevel:to:'

  # Re-add behavior which was removed in GS 3.1.0.1
  def __frame_at_temp_named_put(frameidx, tempname, value)
    offset = __frame_at_offset_of_temp_named(frameidx, tempname)
    __frame_at_temp_at_put(frameidx, offset, value)
  end
end

# require 'maglev/objectlog'

# class Thread
#   # => GsNMethod
#   primitive '__method_at', 'methodAt:'
#   # => Fixnum
#   primitive '__stack_depth', 'stackDepth'
#   # Remove all frames above [Fixnum]
#   primitive '__trim_stack_to_level', '_trimStackToLevel:'
#   # Change temporary at level to value
#   primitive '__frame_at_temp_named_put', '_frameAt:tempNamed:put:'
#   # => Array
#   #    with:
#   #  1  gsMethod
#   #  2  self
#   #  4  selector
#   #  5  quickStepPoint (offset into sourceOffsets)
#   #  6  sourceOffsets (the points where each step would be at)
#   #  7  argAndTempNames
#   #  8  argAndTempValues (maybe smaller or larger than argAndTempNames)
#   #  9  sourceString
#   #  10 ipOffset
#   #  11 markerOrException
#   primitive '__gsi_debugger_detailed_report_at', '_gsiDebuggerDetailedReportAt:'
#   # Stepping
#   primitive '__step_over_in_frame', '_stepOverInFrame:'
#   # Persistence conversions
#   primitive 'convert_to_persistable_state', "convertToPersistableState"
#   primitive 'convert_to_runnable_state', 'convertToRunnableState'
#   primitive '__ar_stack', 'arStack'
#   primitive '__client_data', '_clientData'
#   #  Private.  Returns an Array describing the specified level in the receiver.
#   #  aLevel == 1 is top of stack.  If aLevel is less than 1 or greater than
#   #  stackDepth, returns nil.
#   #  The result Array contains:
#   #  offset item
#   #  -----  -----
#   #    0    gsMethod
#   #    1    ipOffset
#   #    2    frameOffset (zero-based)
#   #    3    varContext
#   #    4    saveProtectedMode
#   #    5    markerOrException
#   #    6    nil (not used)
#   #    7    self (possibly nil in a ComplexBlock)
#   #    8    argAndTempNames (an Array of Symbols or Strings)
#   #    9    receiver
#   #   10    arguments and temps, if any
#   primitive '__frame_contents_at', '_frameContentsAt:'
#   primitive '__run' , 'rubyRun'
#   primitive '__wakeup', 'rubyResume'
#   primitive '__value', 'value:'

#   # Resuming a continuation is only possible through this method
#   def run_callcc(ret_val = nil)
#     __value(ret_val)
#   end

#   def run
#     if in_persistable_state?
#       raise RuntimeError, "You have to call #resume_continuation on the ObjectLogEntry for this Thread"
#     end
#     __run
#   end

#   def wakeup
#     if in_persistable_state?
#       raise RuntimeError, "You have to call #resume_continuation on the ObjectLogEntry for this Thread"
#     end
#     __wakeup
#   end

#   # Simple check whether the thread looks like as if it is in a persistable (i.e.
#   # non-runnable) state
#   def in_persistable_state?
#     return true if thread_data.nil?
#     thread_data.collect(&:class).collect(&:name).include? :RubyPersistableCompilerState
#   end

#   # Saves the Thread to the ObjectLog.
#   #
#   # @param [String] message the message under which to save the entry,
#   #   defaults to inspect and timestamp
#   # @param [Boolean] force_commit whether or not to force a commit.
#   #   Defaults to nil, which means it'll commit if the session is clean or raise
#   #   an error. Pass true to forcibly abort and commit only the log entry, pass
#   #   false to only commit if the session is clean.
#   # @return [DebuggerLogEntry] the saved entry
#   # @raise [RuntimeError] raised if the session is dirty but no force_commit
#   #   option has been passed
#   def save(message = nil, force_commit = nil)
#     if Maglev.needs_commit and force_commit.nil?
#       raise RuntimeError, "Saving exception to ObjectLog, discarding transaction"
#     end
#     message ||= "#{inspect}-#{DateTime.now}"
#     Maglev.abort_transaction if force_commit || !Maglev.needs_commit
#     DebuggerLogEntry.create_continuation_labeled(message)
#     Maglev.commit_transaction if force_commit || !Maglev.needs_commit
#     self
#   end

#   # Remove Thread from ObjectLog
#   def delete
#     if Maglev::System.needs_commit
#       raise Exception, "Abort would loose data. Commit your data and try again"
#     end
#     Maglev.abort_transaction
#     ObjectLogEntry.object_log.delete(@log_entry)
#     Maglev.commit_transaction
#   end

#   def stack
#     self.__stack_depth.times.collect do |idx|
#       Frame.new(self.__method_at(idx + 1), idx + 1, self)
#     end
#   end

#   def step(symbol = :over)
#     case symbol
#     when :into
#       self.__step_over_in_frame(0)
#     when :over
#       self.__step_over_in_frame(1)
#     when :through
#       raise NotImplementedError, "not implemented yet"
#     when Fixnum
#       self.__step_over_in_frame(symbol)
#     end
#   end

#   primitive '_report', '_reportOfSize:'
#   def report(depth = self.__stack_depth)
#     _report(depth)
#   end

#   # The list of saved threads in the ObjectLog
#   def self.saved_errors
#     ObjectLog.errors
#   end

#   def raw_stack
#     self.__ar_stack || begin # Force data into cache, if neccessary
#                          self.stack
#                          self.__ar_stack
#                        end
#   end

#   def thread_data
#     self.__client_data
#   end

#   def compiler_state
#     self.__client_data.first
#   end

#   VariableContext = __resolve_smalltalk_global(:VariableContext)
#   VariableContext.primitive '[]', 'at:'
#   VariableContext.primitive '[]=', 'at:put:'
#   VariableContext.primitive 'size', 'size'
# end
