require File.expand_path('../spec_helper', __FILE__)
require 'fixtures/method_spec'

describe "MethodMirror" do
  describe "runtime reflection" do
    describe "structural queries" do
      before(:each) do
        @r = Reflection.new(nil)
        @f = MethodSpecFixture
        m = MethodSpecFixture.instance_method(:source_location)
        @m = @r.reflect_object(m)
      end

      it "file" do
        @m.file.should == @f.new.source_location[0]
      end

      it "line" do
        @m.line.should == (@f.new.source_location[1] - 1)
      end

      it "selector" do
        @m.selector.should == @f.new.source_location[2]
      end

      it "defining class" do
        @m.defining_class.should == @f.new.source_location[3]
      end

      it "source" do
        @m.source.should =~ /[__FILE__, __LINE__, __method__.to_s, self.class]/
      end

      it "line=" do
        @m.line = 12
        @m.line.should == 12
        MethodSpecFixture.new.source_location
      end

      it "file=" do
        @m.file = "no_file.rb"
        @m.file.should == "no_file.rb"
      end
      
      it "source=" do
        @m.source = @m.source.sub("__FILE__", "__FILE__.to_s")
        @m.source.should =~ /[__FILE__.to_s, __LINE__, __method__.to_s, self.class]/
        @m.defining_class.should == MethodSpecFixture
        m = @r.reflect_object MethodSpecFixture.instance_method(:source_location)
        m.source.should =~ /[__FILE__.to_s, __LINE__, __method__.to_s, self.class]/
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
          @m.arguments.should include("a", "aa", "b", "bb", "args", "block")
        end

        it "block argument" do
          @m.block_argument.should == "block"
        end

        it "required arguments" do
          @m.required_arguments.should include("a", "aa")
        end

        it "optional arguments" do
          @m.optional_arguments.should include("b", "bb")
        end

        it "splat argument" do
          @m.splat_argument.should == "args"
        end
      end

      it "step_locations" do
        @m.step_offsets.each do |l|
          l.should be_kind_of(Fixnum)
          l.should < @m.source.length
        end
      end

      it "message sends and their offsets" do
        @m.send_offsets.should be_kind_of(Hash)
        @m.send_offsets.keys.should include "to_s"
        @m.send_offsets.values.first.should be_kind_of(Fixnum)
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
        pending
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

      it "returns invocation count" do
        ic = @m.invocation_count
        MethodSpecFixture.new.send(@m.selector)
        @m.invocation_count.should == (ic + 1)
      end

      it "can delete a method from its home class" do
        c = MethodSpecFixture
        m = @r.reflect_object c.instance_method(:removeable_method)
        c.instance_methods.should include("removeable_method")
        m.delete
        c.instance_methods.should_not include("removeable_method")
      end
    end
  end
end
