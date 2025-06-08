# frozen_string_literal: true

require "yaml"

STANDARD_RB_CONFIG_PATH = File.expand_path("../.standard.yml", __dir__).freeze
GEMSPEC_PATH = File.expand_path("../atlasq.gemspec", __dir__).freeze

standard_rb_ruby_version = YAML
  .safe_load_file(STANDARD_RB_CONFIG_PATH)
  .then { |yaml| yaml["ruby_version"] }
  &.to_s

gemspec_min_ruby_version = File
  .read(GEMSPEC_PATH)
  .match(/\.required_ruby_version = ">= (.+)"/)
  &.match(1)

if standard_rb_ruby_version.nil?
  warn "Unable to parse ruby_version from .standard.yml"
  exit(1)
end

if gemspec_min_ruby_version.nil?
  warn "Unable to parse required_ruby_version from atlasq.gemspec"
  exit(1)
end

if standard_rb_ruby_version != gemspec_min_ruby_version
  warn <<~ERROR
    .standard.yml ruby version is #{standard_rb_ruby_version} and
    atlasq.gemspec required_ruby_version is #{gemspec_min_ruby_version}
    which do not match.
  ERROR
  exit(1)
end
