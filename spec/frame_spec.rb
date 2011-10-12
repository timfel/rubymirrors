require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/stack_frame_spec'

describe "StackFrameMirror" do
  before(:each) do
    @r = reflection
    @t = Thread.start do
      t = FrameFixture.new
      t.stop
      t.return
    end
    @m = @r.reflect_object(@t)
    @s = @m.stack
  end

  it "should return StackFrameMirrors when reflecting on a Threads stack" do
    @s.each {|a| a.should be_kind_of Reflection::StackFrameMirror }
  end

  it "the step offset" do
    @s.first.step_offset.should be_kind_of(Fixnum)
  end

  it "the receiver" do
    @s.first.receiver.should be_kind_of(A)
  end

  it "the self" do
    @s.first.self.should be_kind_of(A)
  end

  it "the arguments" do
    @s.first.arguments.keys.should == ["a"]
    @s.first.arguments.values.should == [1]
  end

  it "the locals" do
    @s.first.locals.keys.should == ["a"]
    @s.first.locals.values.should == [1]
  end

  it "the variable context" do
    pending
  end

  it "restart the frame" do
    f = @s.first
    @s.first.restart
    @s.first.should == f
    @s.first.step_offset.should == 1
  end

  it "pop the frame" do
    f = @s.first
    @s.first.pop
    @s.first.should_not == f
    @s.first.step_offset.should == 1
  end

  it "step over the current call" do
    sp = @s.first.step_offset
    @s.first.step(:over)
    @s.first.step_offset.should == sp + 1
  end

  it "step into the next call" do
    f = @s.first
    @s.first.step(:into)
    @s.first.step_offset.should == 1
    @s.first.should_not == f
    @s[1].should == f
  end
end
