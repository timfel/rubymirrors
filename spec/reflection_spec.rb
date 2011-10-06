require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/reflect_spec'

describe Reflection do
  it "returns the type of codebase it can work on" do
    Reflection.codebase.should be_kind_of(Class)
  end

  describe "queries" do
    before do
      @r = reflection
    end

    it "finds known modules" do
      modules = @r.modules.collect(&:name)
      modules.should include("ReflectModule")
      modules.should_not include("ReflectClass")
    end

    it "finds known classes" do
      classes = @r.classes.collect(&:name)
      classes.should include("ReflectClass")
      classes.should_not include("ReflectModule")
    end

    it "finds known instances of something" do
      class MyObj; end
      class My2Obj < MyObj; end
      a = MyObj.new
      b = My2Obj.new
      instances = @r.instances_of(MyObj).collect(&:name)
      instances.should include(a.inspect)
      instances.should_not include(b.inspect)
    end

    it "can get vm objects id" do
      o = Object.new
      @r.object_by_id(o.object_id).name.should == o.inspect
    end

    it "returns all available threads" do
      t = Thread.start {}
      @r.threads.collect(&:name).should include(t.inspect)
    end

    it "reports a platform" do
      @r.platform.should == RUBY_PLATFORM
    end

    it "reports a ruby implementation" do
      @r.engine.should == RUBY_ENGINE
    end

    it "reports the implementation's version" do
      @r.version.should == Object.const_get(:"#{RUBY_ENGINE.upcase}_VERSION")
    end
  end
end
