$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "markdown"
require "commonmarker"

require "minitest/autorun"

module MiniTest::Assertions
  def assert_markdown(markdown, message = nil)
    expected = CommonMarker.render_html(markdown, :DEFAULT)
    actual = Markdown.render_html(markdown)
    assert_equal(expected, actual)
  end
end
