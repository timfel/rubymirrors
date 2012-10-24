require File.expand_path("../method.rb", __FILE__)
require File.expand_path("../thread.rb", __FILE__)

class ExecBlock
  primitive 'shift', 'shift'
  primitive 'reset', 'reset'
end

class Proc
  def __shift
    @_st_block.shift
  end

  def __reset
    @_st_block.reset
  end
end

class Thread
  primitive 'call', 'call:'
end
