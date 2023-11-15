# frozen_string_literal: true

class UtilTest < Minitest::Test
  def test_string_titleize
    [
      "One Two Three",
      "one two three",
      "OnE tWo ThReE",
      "one_two_three",
      :one_two_three
    ].each do |string|
      assert_equal "One Two Three", Atlasq::Util::String.titleize(string)
    end
  end
end
