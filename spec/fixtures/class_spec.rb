module ClassFixtureModule
end

class ClassFixture
  Foo = "Bar"

  class ClassFixtureNested
    class ClassFixtureNestedNested
    end
  end
  include ClassFixtureModule

  attr_accessor :b
  def a
    @a = 1
    @@cvb = 1
  end

  @@cva = 1
  @civa = 1

  def self.b
    @@cvc = 1
    @civb = 1
  end
end

class ClassFixtureSubclass < ClassFixture; end
class ClassFixtureSubclassSubclass < ClassFixtureSubclass; end
