require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/field_spec'

describe "FieldMirror" do
  describe "variables", :shared => true do
    it "reports the ivar name as name" do
      @m.name.should == @nom
    end

    it "reports the var value" do
      @m.value.name.should == @nom.sub(/@@?/, '').inspect
    end

    it "can change the value" do
      old_value = @o.send(:"#{@class_side}_variable_get", @nom)
      @m.value = "changed"
      @o.send(:"#{@class_side}_variable_get", @nom).should == "changed"
      @m.value = old_value
    end

    it "always shows the current value" do
      @m.value.name.should == @nom.sub(/@@?/, '').inspect
      @o.send(:"#{@class_side}_variable_set", @nom, "changed")
      @m.value.name.should == "changed".inspect
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
      @om = reflection.reflect(@o)
      @m = @om.variables.first
      @nom = "@ivar"
      @class_side = "instance"
    end

    it_behaves_like "variables", "instance variables"
  end

  describe "class instance variables" do
    before(:each) do
      @o = FieldFixture
      @om = reflection.reflect(@o)
      @m = @om.variables.first
      @nom = "@civar"
      @class_side = "instance"
    end

    it_behaves_like "variables", "class instance variables"
  end

  describe "class variables" do
    before(:each) do
      @o = FieldFixture
      @om = reflection.reflect(@o)
      @m = @om.class_variables.first
      @nom = "@@cvar"
      @class_side = "class"
    end

    it_behaves_like "variables", "class variables"
  end

  describe "constants" do
    before(:each) do
      @o = FieldFixture
      @om = reflection.reflect(@o)
      @m = @om.constants.first
      @name = "CONSTANT"
    end

    it "reports the constant name as name" do
      @m.name.should == @name
    end

    it "reports the ivar value" do
      @m.value.name.should == @name.downcase.inspect
    end

    it "can change the value" do
      old_value = @m.value.reflectee
      @m.value = "changed"
      @o.const_get(@name).should == "changed"
      @m.value = old_value
    end

    it "always shows the current value" do
      @m.value.name.should == @name.downcase.inspect
      @o.const_set(@name, "changed")
      @m.value.name.should == "changed".inspect
    end

    it "reports constants as public" do
      @m.private?.should be_false
      @m.protected?.should be_false
      @m.public?.should be_true
    end

    it "can delete a constant" do
      @m.delete
      @om.constants.should_not include @m

      @m = @om.reflectee.const_set(@m.name, @name)
    end

    it "can add a constant" do
      cst = @om.constant("MyNewlyAddedConstant")
      @om.constants.collect(&:name).should_not include("MyNewlyAddedConstant")
      cst.value = "MyNewlyAddedConstant"
      @om.constants.collect(&:name).should include("MyNewlyAddedConstant")
    end
  end
end
