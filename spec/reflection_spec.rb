require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/reflect_spec'
require 'uri'

describe Reflection do
  it "returns the type of codebase it can work on" do
    Reflection.codebase.should be_kind_of(Class)
  end

  describe "queries" do
    before do
      case Reflection.codebase
      when File
        @r = Reflection.reflect("fixtures/reflect")
      when NilClass
        @r = Reflection.reflect(nil)
      when URI
        run_drb_vm
        @r = Reflection.reflect(URI::Generic.new("drb", "127.0.0.1", "9128"))
      end
    end

    it "finds known modules" do
      @r.modules.collect(&:name).should include("ReflectModule")
    end

    it "finds known classes" do
      @r.classes.collect(&:name).should include("ReflectModule")
    end

    it "finds known instances of something" do
      @r.instances_of(String).should include("foo")
    end

    it "returns available threads" do
      t = Thread.start {}
      @r.threads.collect(&:name).should include(t.inspect)
    end
  end
end
