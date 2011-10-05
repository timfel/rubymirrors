require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/class_spec'

describe "ClassMirror" do
  module TestMixin
  end

  class TestClass
    Foo = "Bar"

    class TestClassInner; end
    include TestMixin

    attr_accessor :b
    def a
      @a = 1
      @@cvb = 1
    end

    @@cva = 1
    @civa = 1

    def self.b
      @@cvc = 1
      @civb = 1
    end
  end

  class TestBClass < TestClass; end

  before do
    @m = Reflection.current.reflect_class(TestClass)
  end

  describe "queries" do
    alias the it

    the "name" do
      @m.name.should == TestClass.name
    end

    the "known instance variables" do
      @m.instance_variables.should include("@a", "@b")
    end

    the "known class variables" do
      @m.class_variables.should include("@@cva", "@@cvb", "@@cvc")
    end

    the "known class instance variables" do
      @m.class_instance_variables.should include("@civa", "@civb")
    end

    the "known constants" do
      @m.constants.keys.should == ["Foo"]
      @m.constants.values.should == ["Bar"]
    end

    the "known inner classes" do
      @m.nested_classes.first.should.be_kind_of(@m.class)
      @m.nested_classes.first.name.should == TestClassInner.name
    end

    the "known direct methods" do
      @m.methods.size.should == 2
    end

    the "ancestors" do
      @m.ancestors.each {|a| a.should.be_kind_of(@m.class) }
    end

    the "superclass" do
      @m.superclass.should.be_kind_of(@m.class)
    end

    the "known subclasses" do
      @m.subclasses.size.should == 1
    end

    the "mixins" do
      @m.mixins.first.name.should == TestMixin.name
    end

    the "nesting" do
      @m.nesting.last.should.be_kind_of(@m.class)
      @m.nesting.last.name.should == TestClass.name
    end

    the "source locations" do
      @m.source_files.any? {|l| l =~ /spec\/class_spec.rb/ }.should.be_true
      @m.source_files.any? {|l| l =~ /fixtures\/class_spec.rb/ }.should.be_true
    end

    the "value of a known constant" do
      @m.value_of("Foo").should == "Bar"
    end

    the "value of a known class variable" do
      @m.value_of("cva").should == 1
    end

    the "value of a known class instance variable" do
      @m.value_of("cvia").should == 1
    end
  end
end
