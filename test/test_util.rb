# frozen_string_literal: true

class UtilTest < Minitest::Test
  def test_word_map_search
    word_map = Atlasq::Util::WordMap.new(index: {
      "1" => %w[odd digit], "2" => %w[even digit], "3" => %w[odd digit],
      "4" => %w[even digit], "5" => %w[odd digit], "6" => %w[even digit],
      "7" => %w[odd digit], "8" => %w[even digit], "9" => %w[odd digit],
      "10" => %w[even digit]
    })

    assert_equal %w[digit even], word_map.search("2")
    assert_equal %w[digit odd], word_map.search("9")
    assert_equal %w[digit], word_map.search("10;   7 (4) 3")
    assert_empty word_map.search("eleven ten")
  end
end
