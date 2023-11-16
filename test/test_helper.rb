# frozen_string_literal: true

ENV.delete("ATLASQ_DEBUG")

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "atlasq"

require "minitest/autorun"
