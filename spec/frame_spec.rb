require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/stack_frame_spec'

describe "StackFrameMirror" do
  before(:each) do
    @r = reflection
    @t = Thread.start do
      t = FrameFixture.new
      t.my_stop("argument_value")
      t.my_return
    end
    @m = @r.reflect_object(@t)
    @s = @m.stack
    @f = @s.detect {|frame| frame.name == "my_stop" }
  end

  it "should return StackFrameMirrors when reflecting on a Threads stack" do
    @s.each {|a| a.should be_kind_of Reflection::StackFrameMirror }
  end

  it "the step offset" do
    @f.step_offset.should be_kind_of Fixnum
  end

  it "the source offset" do
    offs = @f.source_offset
    offs.should be_kind_of Fixnum
    offs.should < @f.method.source.size
  end

  it "the receiver" do
    @f.receiver.target_class.name.should == "FrameFixture"
  end

  it "the self should be the receiver for a regular method" do
    @f.self.reflectee.should == @f.receiver.reflectee
  end

  it "the arguments" do
    @f.arguments.keys.should == ["argument"]
    @f.arguments.values.collect(&:name).should == ["argument_value".inspect]
  end

  it "the locals" do
    @f.locals.keys.should include "local"
    @f.locals.values.collect(&:name).should include "local_value".inspect
  end

  it "the variable context" do
    pending
  end

  it "restart the frame" do
    prev_step_offset = @f.step_offset
    @f.restart
    @f.step_offset.should < prev_step_offset
    @m.stack.first.should == @f
  end

  it "pop the frame" do
    frame_before_f = @s[@s.index(@f) + 1]
    @f.pop
    @m.stack.first.should == frame_before_f
  end

  it "step over the current call" do
    @f.restart
    prev_step_offset = @f.step_offset
    @f.step(:over)
    @f.step_offset.should == prev_step_offset + 1
  end

  it "step into the next call" do
    @f.restart
    @f.step(:into)
    @m.stack[0].should_not == @f
    @m.stack[1].should == @f
  end
end
