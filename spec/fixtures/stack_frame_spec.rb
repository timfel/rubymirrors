class FrameFixture
  def stop; Thread.stop; end
  def return; 2; end
  def raise; raise "stop"; end
end
