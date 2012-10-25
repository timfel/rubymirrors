Gem::Specification.new do |s|
  s.name          = "rubymirrors"
  s.version       = "0.0.3"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tim Felgentreff"]
  s.email         = ["timfelgentreff@gmail.com"]
  s.summary       = "Mirror API for Ruby"
  s.description   = File.read(File.expand_path("../README.md", __FILE__))
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
