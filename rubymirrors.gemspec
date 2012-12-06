Gem::Specification.new do |s|
  s.name          = "rubymirrors"
  s.version       = "0.0.1"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tim Felgentreff"]
  s.email         = ["timfelgentreff@gmail.com"]
  s.summary       = "Mirror API for Ruby"
  s.description   = "Provides a number of specs and classes that document a mirror API for Ruby."
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
