require "test_helper"

class MarkdownTest < Minitest::Test
  def test_paragraph
    assert_markdown "hello"
    assert_markdown "hello\nworld"
    assert_markdown "hello\nworld\nagain"
    assert_markdown "hello\n\nworld"
    assert_markdown "hello\n\nworld\n\nagain"
  end
end
