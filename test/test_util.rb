# frozen_string_literal: true

class UtilTest < Minitest::Test
  def test_word_map_search
    word_map = Atlasq::Util::WordMap.new({
      "even" => ["2 4 6 8 10", "two four six eight ten"],
      "odd" => ["1 3 5 7 9", "one three five seven nine"],
      "digits" => ["1, 2, 3, 4, 5, 6, 7, 8, 9, 10"],
      "tens" => ["10 20 30 40 50", "ten twenty thirty fourty fifty"],
    })

    assert_equal %w[digits even], word_map.search("2")
    assert_equal %w[digits odd], word_map.search("9")
    assert_equal %w[digits even tens], word_map.search("10")
    assert_equal %w[tens], word_map.search("10;   twenty 30  (fourty) 50")
    assert_empty word_map.search("eleven ten")
  end
end
