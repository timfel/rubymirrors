require 'uri'

class Object
  def reflection
    map = { File => proc { Reflection.reflect("fixtures/reflect") },
      NilClass => proc { Reflection.reflect(nil) },
      URI => proc do
        run_drb_vm
        Reflection.reflect(URI::Generic.new("drb", "127.0.0.1", "9128"))
      end }
    map[Reflection.codebase][]
  end
end

