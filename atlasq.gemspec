# frozen_string_literal: true

require_relative "lib/atlasq/version"

Gem::Specification.new do |spec|
  spec.name = "atlasq"
  spec.version = Atlasq::VERSION
  spec.authors = ["Kevin Robell"]
  spec.email = ["apainintheneck@gmail.com"]

  spec.summary = "Query for regional info at the command line."
  spec.description = "Country, state, and currency info at your fingertips. Query for regional info and see which countries show up."
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
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
