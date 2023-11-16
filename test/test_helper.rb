# frozen_string_literal: true

ENV.delete("ATLASQ_DEBUG")

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "atlasq"

require "minitest/autorun"

FIXTURE_DIRECTORY = File.absolute_path("fixtures", __dir__).freeze

# @param file_name [String]
# @return [String] file contents
def fixture(file_name)
  path = File.absolute_path(file_name, FIXTURE_DIRECTORY)
  File.read(path)
end
