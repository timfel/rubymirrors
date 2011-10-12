class GuardException
  def initialize(example, exception)
    @message = example && example.description || "<no description>"
    @exception = exception
    @method = exception.backtrace.first
  end

  def finish(*args)
    print "Skipped '#{@message}'\n\t#{@exception}\n\tin #{@method}).\n\n"
  end
end

module MSpec
  class << self
    alias mspec_protect protect

    def protect(location, &block)
      wrapped_block = proc do
        begin
          instance_eval(&block)
        rescue *MSpec.retrieve(:guarding_exceptions)
          MSpec.expectation
          MSpec.register :finish, GuardException.new(MSpec.current.state, $!)
        end
      end
      mspec_protect(location, &wrapped_block)
    end
  end
end
