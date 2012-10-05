$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "git-autobisect"
version = File.read(File.expand_path("../VERSION", __FILE__))

Gem::Specification.new name, version do |s|
  s.summary = "Find the first broken commit without having to learn git bisect"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.executables = ["git-autobisect"]
  s.license = "MIT"
end
