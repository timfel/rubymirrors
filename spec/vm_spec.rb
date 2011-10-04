describe "VMMirror" do
  class VMMirrorTest_A
  end

  module VMMirrorTest_B
  end

  before do
    @m = VMMirror.reflect(VMMirror.current_vm)
  end

  describe "queries" do
    alias the it

    the "known classes" do
      cls = @m.classes.detect {|c| c.name == "VMMirrorTest_A" }
      cls.should.be_kind_of(ClassMirror)
    end

    the "known modules" do
      cls = @m.modules.detect {|c| c.name == "VMMirrorTest_B" }
      cls.should.be_kind_of(ClassMirror)
    end

    the "vm platform" do
      @m.platform.should == RUBY_PLATFORM
    end

    the "vm implementation" do
      @m.engine.should == RUBY_ENGINE
    end

    the "vm implementation's version" do
      @m.version.should == Object.const_get(:"#{RUBY_ENGINE}_VERSION")
    end

    the "vm mirror capabilites" do
      pending
    end
  end

  it "can get any vm object by id" do
    o = Object.new
    @m.object_by_id(o.object_id).should == o
  end
end
