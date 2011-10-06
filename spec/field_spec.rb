require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/field_spec'

describe "FieldMirror" do
  describe "variables", :shared => true do
    it "reports the ivar name as name" do
      @m.name.should == "@#{@nom}"
    end

    it "reports the var value" do
      @m.value.should == @nom
    end

    it "can change the value" do
      @m.value = "changed"
      @o.send(:"#{@class_side}_variable_get", "@#{@nom}").should == "changed"
    end

    it "always shows the current value" do
      @m.value.should == @nom
      @o.send(:"#{@class_side}_variable_set", "@#{@nom}", "changed")
      @m.value.should == "changed"
    end

    it "reports vars as private only" do
      @m.private?.should be_true
      @m.protected?.should be_false
      @m.public?.should be_false
    end
  end

  describe "instance variables" do
    before(:each) do
      @o = FieldFixture.new
      @om = reflection.reflect_object(@o)
      @m = @om.variables.first
      @nom = "ivar"
      @class_side = "instance"
    end

    it_behaves_like "variables", "instance variables"
  end
  
  describe "class instance variables" do
    before(:each) do
      @o = FieldFixture
      @om = reflection.reflect_object(@o)
      @m = @om.variables.first
      @nom = "civar"
      @class_side = "instance"
    end

    it_behaves_like "variables", "class instance variables"
  end
  
  describe "class variables" do
    before(:each) do
      @o = FieldFixture
      @om = reflection.reflect_object(@o)
      @m = @om.class_variables.first
      @nom = "cvar"
      @class_side = "class"
    end

    it_behaves_like "variables", "class variables"
  end

  describe "constants" do
    before(:each) do
      @o = FieldFixture
      @om = reflection.reflect_object(@o)
      @m = @om.constants.first
      @name = "CONSTANT"
    end

    it "reports the constant name as name" do
      @m.name.should == @name
    end

    it "reports the ivar value" do
      @m.value.should == @name.downcase
    end

    it "can change the value" do
      @m.value = "changed"
      @o.const_get(@name).should == "changed"
    end

    it "always shows the current value" do
      @m.value.should == @name.downcase
      @o.const_set(@name, "changed")
      @m.value.should == "changed"
    end

    it "reports constants as public" do
      @m.private?.should be_false
      @m.protected?.should be_true
      @m.public?.should be_true
    end
  end
end
