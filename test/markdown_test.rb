require "test_helper"

class MarkdownTest < Minitest::Test
  def test_paragraph
    assert_markdown "hello"
  end

  def test_paragraph_with_newline
    assert_markdown "hello\nworld"
  end
end
