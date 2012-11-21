$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "utf8_translatable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "utf8_translatable"
  s.version     = Utf8Translatable::VERSION
  s.authors     = ["Nico Arbogast"]
  s.email       = ["nicolas.arbogast@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Adds self translating methods to ActiveRecord models"
  s.description = "Example: Given an ActiveRecord model with columns name_en and name_fr, adding ensures_translated_and_utf8 to the model will provide a _name method returning the correct column given current I18n.locale"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.9"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
end
