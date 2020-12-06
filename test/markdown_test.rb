require "test_helper"

class MarkdownTest < Minitest::Test
  def test_empty
    assert_markdown ""
    assert_markdown " "
    assert_markdown "\n"
  end

  def test_paragraph
    assert_markdown "hello"
    assert_markdown "hello\nworld"
    assert_markdown "hello\nworld\nagain"
    assert_markdown "hello\n\nworld"
    assert_markdown "hello\n\nworld\n\nagain"
  end

  def test_atx_heading
    assert_markdown "# hello"
    assert_markdown "## hello"
    assert_markdown "### hello"
    assert_markdown "#### hello"
    assert_markdown "##### hello"
    assert_markdown "###### hello"

    assert_markdown "####### hello"
  end

  def test_unordered_list
    assert_markdown "- hello"
    assert_markdown "- hello\n- world"

    assert_markdown "+ hello"
    assert_markdown "+ hello\n+ world"

    assert_markdown "* hello"
    assert_markdown "* hello\n* world"

    assert_markdown "- hello\n- world\n* again"
    assert_markdown "- hello\n+ world\n* again"
  end
end
