name = "git-autobisect"
require "./lib/git/autobisect/version"

Gem::Specification.new name, Git::Autobisect::Version do |s|
  s.summary = "Find the first broken commit without having to learn git bisect"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/`.split("\n")
  s.executables = ["git-autobisect"]
  s.license = "MIT"
  s.required_ruby_version = '>= 2.2.0'
end
