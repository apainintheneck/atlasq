# frozen_string_literal: true

require_relative "lib/atlasq/version"

Gem::Specification.new do |spec|
  spec.name = "atlasq"
  spec.version = Atlasq::VERSION
  spec.authors = ["Kevin Robell"]
  spec.email = ["apainintheneck@gmail.com"]

  spec.summary = "Query for countries info at the command line."
  spec.description = "Country, region, and currency info at your fingertips. " \
                     "Query for regional info and see which countries show up."
  spec.homepage = "https://github.com/apainintheneck/atlasq"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/apainintheneck/atlasq/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*.rb"]
  spec.bindir = "exe"
  spec.executables = ["atlasq"]
  spec.require_paths = ["lib"]

  spec.add_dependency "countries", "~> 5.7"
  spec.add_dependency "iso-639", "~> 0.3"
  spec.add_dependency "money", "~> 6.9"
  spec.add_dependency "money-heuristics", "~> 0.1.1"
  spec.add_dependency "tty-pager", "~> 0.14"

  spec.metadata["rubygems_mfa_required"] = "true"
end
