class FrameFixture
  def my_stop(argument); local = "local_value"; Thread.stop; end
  def my_return; 2; end
  def my_raise; raise "stop"; end
end
