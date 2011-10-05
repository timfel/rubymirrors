class Reflection
  def reflect_class(klass)
    ClassMirror.reflect(klass)
  end

  def self.current
    @instance ||= Reflection.new
  end

  class Mirror
    attr_reader :subject

    def self.reflect(reflectee)
      self.new(reflectee)
    end

    def initialize(reflectee)
      @subject = reflectee
    end
  end
end

Dir["#{File.dirname(__FILE__)}/*_mirror.rb"].each {|f| require f }
