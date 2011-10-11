require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/method_spec'

describe "MethodMirror" do
  describe "runtime reflection" do
    describe "structural queries" do
      before do
        @r = Reflection.new(nil)
        @m = Reflection.reflect_object(method(:method_a))
      end

      it "filename" do
        @m.file.should == method_a[0]
      end

      it "line" do
        @m.line.should == (method_a[1] - 1)
      end

      it "selector" do
        @m.selector.should == method[2]
      end

      it "defining class" do
        @m.defining_class.should == method[3]
      end
    end

    describe "runtime behavior queries" do
      def method_b(a, aa, b = 1, bb = 2, *args, &block)
        to_s
        super
      end

      before do
        @m = @r.reflect_object(method(:method_b))
      end

      describe "arguments" do
        it "argument list" do
          @m.arguments.should.include("a", "aa", "b", "bb", "args", "block")
        end

        it "block argument" do
          @m.block_argument.should == "block"
        end

        it "required arguments" do
          @m.required_arguments.should.include("a", "aa")
        end

        it "optional arguments" do
          @m.optional_arguments.keys.should.include("b", "bb")
          @m.optional_arguments.values.should.include(1, 2)
        end

        it "splat argument" do
          @m.splat_argument.should == "args"
        end
      end

      it "step_locations" do
        @m.step_locations.each do |l|
          l.should.be_kind_of(Fixnum)
          l.should < @m.source.length
        end
      end

      it "message sends and their offsets" do
        @m.message_sends.should.be_kind_of(Hash)
        @m.message_sends.keys.first.should == ["to_s"]
        @m.message_sends.values.first.should.be_kind_of(Fixnum)
      end

      it "ast" do
        pending
      end

      it "bytecodes" do
        pending
      end

      describe "protection" do
        before do
          @cm = @r.reflect_object(MethodSpecFixture)
        end

        it "is public" do
          m = @cm.method(:method_p_public)
          m.public?.should.be_true
          m.protected?.should.be_false
          m.private?.should.be_false
        end

        it "is private" do
          m = @cm.method(:method_p_private)
          m.public?.should.be_false
          m.protected?.should.be_false
          m.private?.should.be_true
        end

        it "is protected" do
          m = @cm.method(:method_p_protected)
          m.public?.should.be_false
          m.protected?.should.be_true
          m.private?.should.be_false
        end
      end

      it "returns native code if it was JITted" do
        @m.native_code
      end

      it "returns average execution time" do
        @m.execution_time_average.should be_kind_of(Time)
      end

      it "can return an approximation about the overall execution time it has been on the stack for" do
        @m.execution_time.should be_kind_of(Time)
      end

      it "returns how many percent of the total process' execution time this method was active" do
        @m.execution_time_share.should be_kind_of(Number)
        @m.execution_time_share.should < 1
        @m.execution_time_share.should > 0
      end

      it "can delete a method from its home class" do
        c = @r.reflect_object(MethodSpecFixture)
        m = c.method("removeable_method")
        c.instance_methods.should include(:removeable_method)
        m.remove
        c.instance_methods.should_not include(:removeable_method)
      end
    end
  end
end
