require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/thread_spec'

describe "ThreadMirror" do
  before(:each) do
    @r = reflection
    @t = Thread.start do
      t = ThreadFixture.new
      t.stop
      t.return
    end
    @m = reflection.reflect(@t)
    sleep 0.1 until @t.stop?
  end

  after(:each) do
    @t.kill
  end

  describe "should query" do
    it "the thread state" do
      @m.status.should == "sleep"
    end

    it "the thread return value" do
      @m.run
      sleep 0.1 until @t.stop?
      @m.return_value.should == ThreadFixture.new.return
    end

    it "the stack" do
      @m.stack.collect(&:name).should include "stop"
    end
  end

  describe "should manipulate" do
    it "should be able to resume the thread" do
      @m.run
      sleep 0.1 while @t.status
      @m.status.should == "dead"
    end
  end

  it "should install exception blocks" do
    @t = Thread.start do
      t = ThreadFixture.new
      t.stop
      t.t_raise
    end
    @m = @r.reflect(@t)
    handled = false
    @m.handle_exception Exception do |e|
      handled = true
    end
    @m.run
    begin @t.join rescue RuntimeError end
    handled.should == true
  end

  it "should handle the right thread exception blocks" do
    t1 = Thread.start do
      t = ThreadFixture.new
      t.stop
      t.t_raise
    end
    t2 = Thread.start do
      t = ThreadFixture.new
      t.stop
      t.t_raise
    end
    m1 = @r.reflect(t1)
    m2 = @r.reflect(t2)
    handled = false
    m1.handle_exception Exception do |e|
      handled = true
    end
    m2.run
    begin t2.join rescue RuntimeError end
    handled.should == false
    m1.run
    begin t1.join rescue RuntimeError end
    handled.should == true
  end

  it "should handle the many thread exception blocks" do
    t1 = Thread.start do
      t = ThreadFixture.new
      t.stop
      t.t_raise
    end
    t2 = Thread.start do
      t = ThreadFixture.new
      t.stop
      t.t_raise
    end
    m1 = @r.reflect(t1)
    m2 = @r.reflect(t2)
    handles = []
    m1.handle_exception Exception do |e|
      handles << "m1"
    end
    m2.handle_exception Exception do |e|
      handles << "m2"
    end
    m1.run
    begin t1.join rescue RuntimeError end
    handles.should include "m1"
    handles.should_not include "m2"
    m2.run
    begin t2.join rescue RuntimeError end
    handles.should include "m1"
    handles.should include "m2"
  end

  describe "implement shift/reset" do
    it "can be used to return early" do
      retval = @r.reflect(Thread.current).reset do
        @r.reflect(Thread.current).shift {|cc| cc.call "shifted" }
        "not returned"
      end

      retval.should == "shifted"
    end

    it "can be run and re-run" do
      retval = @r.reflect(Thread.current).reset do
        @r.reflect(Thread.current).shift do |cc|
          cc.call(cc.call(1))
        end + 1
      end

      retval.should == 3
    end
  end
end
