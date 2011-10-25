class GsNMethod
  primitive_nobridge '__env_id', 'environmentId'
  primitive_nobridge '__home_method', 'homeMethod'
  primitive_nobridge '__in_class', 'inClass'
  primitive '__is_method_for_block', 'isMethodForBlock'
  primitive '__source_string_for_block', '_sourceStringForBlock'
  primitive '__source_offsets', '_sourceOffsets'
  primitive '__source_offsets_of_sends', '_sourceOffsetsOfSends'
  primitive '__source_offset_first_send_of', '_sourceOffsetOfFirstSendOf:'
  primitive '__set_break_at_step_point', 'setBreakAtStepPoint:'
  primitive '__args_and_temps', 'argsAndTemps'
  primitive '__num_args', 'numArgs'
  primitive '__selector', 'selector'
  primitive '__ruby_opt_args_bits', 'rubyOptArgsBits'
  primitive '__ip_steps', '_ipSteps'
  primitive '__opcode_info_at', '_opcodeInfoAt:'
  primitive '__in_class', 'inClass'
end

class UnboundMethod
  def __st_gsmeth
    @_st_gsmeth
  end
end

class GsNMethodWrapper < UnboundMethod
  def initialize(gsmethod); @_st_gsmeth = gsmethod; end
  def inspect; "#<GsNMethodWrapper: #{self.name}>"; end
  def name; @_st_gsmeth.__name; end
end

# class UnboundMethod
#   def step_offsets
#     @_st_gsmeth.__source_offsets
#   end

#   def send_offsets
#     @_st_gsmeth.__source_offsets_of_sends
#   end

#   def break(step_point = 1)
#     if @_st_gsmeth.__is_method_for_block
#       @_st_gsmeth.__set_break_at_step_point(step_point)
#     else
#       self.__nonbridge_meth.__set_break_at_step_point(step_point)
#     end
#   end

#   def in_class
#     @_st_gsmeth.__in_class
#   end

#   def file
#     (@_st_gsmeth.__source_location || [])[0]
#   end

#   def line
#     (@_st_gsmeth.__source_location || [])[1]
#   end

#   def source
#     if @_st_gsmeth.__is_method_for_block
#       @_st_gsmeth.__source_string_for_block
#     else
#       @_st_gsmeth.__source_string
#     end
#   end

#   def file=(path)
#     raise TypeError, "cannot modifiy a block method" if is_method_for_block?
#     @_st_gsmeth.__in_class.class_eval(source, path, line)
#     reload
#   end

#   def line=(num)
#     raise TypeError, "cannot modifiy a block method" if is_method_for_block?
#     @_st_gsmeth.__in_class.class_eval(source, file, num)
#     reload
#   end

#   def source!(str, file_out = false)
#     raise TypeError, "cannot modifiy a block method" if is_method_for_block?
#     if file.nil? && line.nil? # Smalltalk method
#       in_class.__compile_method_category_environment_id(str,
#         '*maglev-webtools-unclassified', 1)
#     else # Ruby method
#       self.original_source = source
#       self.in_class.class_eval(str, file, line)
#       self.file_out(str) if file_out
#     end
#     reload
#   end

#   def file_out(source)
#     if !is_def_method? || is_method_for_block?
#       raise StandardError, "not an ordinary method def"
#     end

#     unless File.writable?(file)
#       raise StandardError, "cannot write to method source file #{file}"
#     end

#     # Write a new file with updated contents
#     original_contents = File.readlines(file)
#     copy = File.open("#{file}.tmp", 'w+') do |f|
#       f.write(original_contents[0...(line - 1)].join)
#       f.write(original_contents[(line - 1)..-1].join.sub(original_source, source))
#     end

#     # Rename to original file
#     File.rename("#{file}.tmp", file)
#   end

#   def reload
#     @_st_gsmeth = in_class.__gs_method(self.name, true)
#     self
#   end

#   attr_writer :original_source
#   def original_source
#     @original_source || source
#   end

#   def is_method_for_block?
#     @_st_gsmeth.__is_method_for_block
#   end

#   def is_def_method?
#     self.original_source =~ /^\s+def\s/
#   end

#   # Answers whether the method send the specified message.
#   # Accepts the following options:
#   #   args => how many arguments in the send (default: 0)
#   #   splat => is there a splat argument (default: false)
#   #   block => is there a block argument (default: false)
#   #   keep => whether to just keep the selector as passed
#   # @return true or false, depending on the result
#   def sends_message?(string, options={})
#     options = {:args => 0, :splat => false,
#       :block => false, :keep => false}.merge(options)
#     unless options[:keep]
#       string = string.to_s + options[:args].to_s +
#         (options[:splat] ? '*' : '_') +
#         (options[:block] ? '&' : '_')
#     end
#     !@_st_gsmeth.__source_offset_first_send_of(string.to_sym).nil?
#   end

#   def ==(other)
#     false unless other === self.class
#     in_class == other.in_class && name == other.name
#   end
# end
