mirror_api = ENV["mirrors"] || "ruby"

$:.push File.expand_path("..", __FILE__)
$:.push File.expand_path("../../lib", __FILE__)
$:.push File.expand_path("../../lib/#{mirror_api}", __FILE__)

require "#{mirror_api}/reflection"

# HACK: Just makes it easier to with different APIs
Reflection = Object.const_get(mirror_api.capitalize).const_get("Reflection")

class GuardException
  def initialize(example, exception)
    @message = example && example.description || "<no description>"
    @exception = exception
    @method = exception.backtrace.first
  end

  def finish(*args)
    print "Skipped '#{@message}' (#{@exception} in #{@method}).\n"
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

MSpec.store :guarding_exceptions, Reflection::CapabilitiesExceeded
