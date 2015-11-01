$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "render_super/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "render_super"
  s.version     = RenderSuper::VERSION
  s.authors     = [""]
  s.email       = ["victor.campos@visagio.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RenderSuper."
  s.description = "TODO: Description of RenderSuper."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
