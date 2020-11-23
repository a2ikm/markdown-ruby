module Markdown
  class Renderer
    attr_reader :paragraph

    def initialize(paragraph)
      @paragraph = paragraph
    end

    def render_html
      render(paragraph)
    end

    def render(node)
      case node.type
      when :paragraph
        render_paragraph(node)
      end
    end

    def render_paragraph(node)
      "<p>" + node.text + "</p>\n"
    end
  end
end
