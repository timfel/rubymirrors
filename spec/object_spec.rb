require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/object_spec'

describe "ObjectMirror" do
  before do
    @r = reflection
  end

  before(:each) do
    @o = ObjectFixture.new
  end

  it "can reflect on objects" do
    @r.reflect_object(@o).should be_kind_of Reflection::Mirror
  end

  describe "ruby behaviours" do
    before do
      @m = @r.reflect_object(@o)
    end

    it "can query instance variables" do
      vars = @m.variables
      vars.collect(&:name).should == ["@ivar"]
      vars.first.should be_kind_of Reflection::Mirror
    end
  end
end
