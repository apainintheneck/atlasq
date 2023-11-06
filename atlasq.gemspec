# frozen_string_literal: true

require_relative "lib/atlasq/version"

Gem::Specification.new do |spec|
  spec.name = "atlasq"
  spec.version = Atlasq::VERSION
  spec.authors = ["Kevin Robell"]
  spec.email = ["apainintheneck@gmail.com"]

  spec.summary = "Query for regional info at the command line."
  spec.description = "Country, state, currency and timezone info at your fingertips. Based on data from ISO standards."
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

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
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "countries", "~> 1.0"
  spec.add_dependency "money", "~> 6.9"
  spec.add_dependency "tty-pager"
  spec.add_dependency "tzinfo", "~> 1.2", ">= 1.2.2"
  spec.metadata["rubygems_mfa_required"] = "true"
end
