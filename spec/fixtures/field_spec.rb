class FieldFixture
  attr_accessor :ivar
  def initialize
    @ivar = "ivar"
  end
  CONSTANT = "constant"
  @@cvar = "cvar"
  @civar = "civar"
end
