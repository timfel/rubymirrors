describe "MethodMirror" do
  describe "runtime reflection" do
    alias the it

    describe "structural queries" do
      def method_a
        [__FILE__, __LINE__, __method__, self.class]
      end

      before do
        @m = MethodMirror.reflect(method(:method_a))
      end

      the "filename" do
        @m.file.should == method_a[0]
      end

      the "line" do
        @m.line.should == (method_a[1] - 1)
      end

      the "method name" do
        @m.name.should == method[2]
      end

      the "defining class" do
        @m.defining_class.should == method[3]
      end
    end

    describe "runtime behavior queries" do
      def method_b(a, aa, b = 1, bb = 2, *args, &block)
        to_s
        super
      end

      before do
        @m = MethodMirror.reflect(method(:method_b))
      end

      describe "arguments" do
        the "argument list" do
          @m.arguments.should.include("a", "aa", "b", "bb", "args", "block")
        end

        the "block argument" do
          @m.block_argument.should == "block"
        end

        the "required arguments" do
          @m.required_arguments.should.include("a", "aa")
        end

        the "optional arguments" do
          @m.optional_arguments.keys.should.include("b", "bb")
          @m.optional_arguments.values.should.include(1, 2)
        end

        the "splat argument" do
          @m.splat_argument.should == "args"
        end
      end

      the "step_locations" do
        @m.step_locations.each do |l|
          l.should.be_kind_of(Fixnum)
          l.should < @m.source.length
        end
      end

      the "message sends and their offsets" do
        @m.message_sends.should.be_kind_of(Hash)
        @m.message_sends.keys.first.should == ["to_s"]
        @m.message_sends.values.first.should.be_kind_of(Fixnum)
      end

      the "ast" do
        pending
      end

      the "bytecodes" do
        pending
      end

      describe "protection" do
        def method_p_public; end
        def method_p_private; end
        private :method_p_private
        def method_p_protected; end
        protected :method_p_protected

        it "is public" do
          m = MethodMirror.reflect(method(:method_p_public))
          m.public?.should.be_true
          m.protected?.should.be_false
          m.private?.should.be_false
        end

        it "is private" do
          m = MethodMirror.reflect(method(:method_p_private))
          m.public?.should.be_false
          m.protected?.should.be_false
          m.private?.should.be_true
        end

        it "is protected" do
          m = MethodMirror.reflect(method(:method_p_protected]))
          m.public?.should.be_false
          m.protected?.should.be_true
          m.private?.should.be_false
        end
      end
    end
  end
end
