class ThreadFixture
  def stop; Thread.stop; end
  def return; 2; end
  def t_raise; raise "stop"; end
end
