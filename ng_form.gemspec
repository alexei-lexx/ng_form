$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ng_form/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ng_form"
  s.version     = NgForm::VERSION
  s.authors     = ["Alexei Lexx"]
  s.email       = ["alexei.lexx@gmail.com"]
  s.homepage    = "https://github.com/alexei-lexx/ng_form"
  s.summary     = "View helpers to create form with twitter bootstrap layout and AngularJS support "

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
