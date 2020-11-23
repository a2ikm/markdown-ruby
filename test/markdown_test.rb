require "test_helper"

class MarkdownTest < Minitest::Test
  def test_paragraph
    assert_markdown "hello"
    assert_markdown "hello\nworld"
    assert_markdown "hello\nworld\nagain"
    assert_markdown "hello\n\nworld"
    assert_markdown "hello\n\nworld\n\nagain"
  end

  def test_heading
    assert_markdown "# hello"
    assert_markdown "## hello"
    assert_markdown "### hello"
    assert_markdown "#### hello"
    assert_markdown "##### hello"
    assert_markdown "###### hello"
  end
end
