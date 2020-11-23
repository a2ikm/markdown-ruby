require "test_helper"

class MarkdownTest < Minitest::Test
  def test_paragraph
    assert_markdown "hello"
  end

  def test_paragraph_with_newline
    assert_markdown "hello\nworld"
    assert_markdown "hello\nworld\nagain"
  end

  def test_paragraphs
    assert_markdown "hello\n\nworld"
    assert_markdown "hello\n\nworld\n\nagain"
  end
end
