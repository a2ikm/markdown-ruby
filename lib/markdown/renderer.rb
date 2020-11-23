module Markdown
  class Renderer
    attr_reader :document

    def initialize(document)
      @document = document
    end

    def render_html
      render(document)
    end

    def render(node)
      case node.type
      when :document
        render_document(node)
      when :heading
        render_heading(node)
      when :paragraph
        render_paragraph(node)
      end
    end

    def render_document(node)
      node.blocks.map { |block| render(block) }.join
    end

    def render_heading(node)
      "<h%d>%s</h%d>\n" % [node.level, node.text, node.level]
    end

    def render_paragraph(node)
      "<p>" + node.text + "</p>\n"
    end
  end
end
