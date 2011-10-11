require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/stack_frame_spec'

describe "StackFrameMirror" do
  before(:each) do
    @t = Thread.start { A.new.thread_op_a }
    @m = ThreadMirror.reflect(@t)
    @s = @m.stack
  end

  it "should return StackFrameMirrors when reflecting on a Threads stack" do
    @s.each {|a| a.should.be_kind_of(StackFrameMirror) }
  end

  describe "should query" do
    it "the frame state" do
      @s.first.status.should == "active"
      @s[1..-1].each {|f| f.status.should == "suspended" }
    end

    it "the frame method" do
      @s.first.method.should.be_kind_of(MethodMirror)
    end

    it "the step point" do
      @s.first.step_point.should.be_kind_of(Fixnum)
    end

    it "the receiver" do
      @s.first.receiver.should.be_kind_of(A)
    end

    it "the self" do
      @s.first.self.should.be_kind_of(A)
    end

    it "the arguments" do
      @s.arguments.keys.should == ["a"]
      @s.arguments.values.should == [1]
    end

    it "the locals" do
      @s.locals.keys.should == ["a"]
      @s.locals.values.should == [1]
    end

    it "the variable context" do
      pending
    end
  end

  describe "should manipulate" do
    it "restart the frame" do
      f = @s.first
      @s.first.restart
      @s.first.should == f
      @s.first.step_point.should == 1
    end

    it "pop the frame" do
      f = @s.first
      @s.first.pop
      @s.first.should_not == f
      @s.first.step_point.should == 1
    end

    it "step over the current call" do
      sp = @s.first.step_point
      @s.first.step(:over)
      @s.first.step_point.should == sp + 1
    end

    it "step into the next call" do
      f = @s.first
      @s.first.step(:into)
      @s.first.step_point.should == 1
      @s.first.should_not == f
      @s[1].should == f
    end
  end
end
