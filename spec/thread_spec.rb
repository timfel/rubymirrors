describe "ThreadMirror" do
  def thread_op_a; 1; end
  def thread_op_b; 2; end
  def thread_op_c; raise "stop"; end

  before(:each) do
    @t = Thread.start { thread_op_a; Thread.stop; thread_op_a }
    @m = ThreadMirror.reflect(@t)
  end

  describe "should query" do
    it "the thread state" do
      @m.status.should == "sleep"
    end

    it "the thread return value" do
      @m.run
      @m.return_value.should == thread_op_a
    end

    it "the stack" do
      @m.stack.should.be_kind_of(Array)
    end
  end

  describe "should manipulate" do
    it "should be able to resume the thread" do
      @m.run
      Thread.pass
      @m.status.should == "dead"
    end
  end
end
