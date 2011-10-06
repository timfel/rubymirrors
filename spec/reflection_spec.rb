require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/reflect_spec'
require 'uri'

describe Reflection do
  it "returns the type of codebase it can work on" do
    Reflection.codebase.should be_kind_of(Class)
  end

  describe "queries" do
    before do
      map = { File => proc { Reflection.reflect("fixtures/reflect") },
        NilClass => proc { Reflection.reflect(nil) },
        URI => proc do
          run_drb_vm
          Reflection.reflect(URI::Generic.new("drb", "127.0.0.1", "9128"))
        end }
      @r = map[Reflection.codebase][]
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

    it "returns all available threads" do
      t = Thread.start {}
      @r.threads.collect(&:name).should include(t.inspect)
    end
  end
end
