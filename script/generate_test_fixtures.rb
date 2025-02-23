# frozen_string_literal: true

require "shellwords"

EXECUTABLE_PATH = File.expand_path("../exe/atlasq", __dir__).freeze

def atlasq(*args)
  escaped_args = args
    .map(&Shellwords.method(:escape))
    .join(" ")

  `#{EXECUTABLE_PATH} #{escaped_args}`
end

FIXTURE_PATH = File.expand_path("../test/fixtures", __dir__).freeze

[
  ["all_countries_output.txt", %w[--countries]],
  ["all_currencies_output.txt", %w[--money]],
  ["all_languages_output.txt", %w[--languages]],
  ["all_regions_output.txt", %w[--regions]]
].each do |filename, args|
  path = File.join(FIXTURE_PATH, filename)
  content = atlasq(*args)
  File.write(path, content)
end
