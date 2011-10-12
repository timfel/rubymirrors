require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/object_spec'

describe "ObjectMirror" do
  before do
    @r = reflection
  end

  before(:each) do
    @o = ObjectFixture.new
    @m = @r.reflect_object(@o)
  end

  it "can query instance variables" do
    vars = @m.variables
    vars.collect(&:name).should == ["@ivar"]
  end
end
