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
    @m = reflection.reflect_object(@t)
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
      @m.return_value.should == ThreadFixture.new.return
    end

    it "the stack" do
      @m.stack.collect(&:name).should include "stop"
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
