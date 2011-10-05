require 'reflection'

module Ruby
  class Reflection < ::Reflection
    def self.codebase
      nil.class
    end

    def self.reflect(ignored)
      self.new
    end
  end
end

