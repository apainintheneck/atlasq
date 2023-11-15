# frozen_string_literal: true

require "test_helper"

class AtlasqTest < Minitest::Test
  def test_version_number
    refute_nil ::Atlasq::VERSION
  end
end
