require "test_helper"

class MarkdownTest < Minitest::Test
  def test_paragraph
    assert_markdown "hello"
  end
end
