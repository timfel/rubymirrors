require 'mspec'

include Mirrors

describe "Mirror" do
  before do
    @m = ClassMirror.reflect(TestClass)
  end

  it "should allow access to statically known instance variables" do
    ClassMirror
  end
end
