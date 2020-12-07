require "markdown/version"
require "markdown/node"

module Markdown
  def self.render_html(markdown)
    document = parse(markdown)
    render(document)
  end

  def self.parse(markdown)
    e = markdown.each_line
    document = Document.new
    parse_blocks(e, document)
    document
  end

  def self.parse_blocks(e, document)
    current = nil
    text = nil

    while line = e.next rescue nil
      line.strip!

      if line.empty?
        if current
          current = nil
        end
        next
      elsif m = line.match(/(\A\#{1,6})\s+(.+)/)
        heading = Heading.new(m[1].length)
        text = Text.new(m[2])
        heading.append(text)
        document.append(heading)
        current = nil
      elsif m = line.match(/([-+*])\s+(.+)/)
        if current.instance_of?(ListItem) && current.parent.disc == m[1]
          list_item = ListItem.new
          text = Text.new(m[2])
          list_item.append(text)
          current.parent.append(list_item)
          current = list_item
        else
          list = List.new(m[1])
          text = Text.new(m[2])
          document.append(list)
          list_item = ListItem.new
          list_item.append(text)
          list.append(list_item)
          current = list_item
        end
      elsif current
        text.append(line)
      else
        text = Text.new(line)
        paragraph = Paragraph.new
        paragraph.append(text)
        document.append(paragraph)
        current = paragraph
      end
    end
  end

  def self.render(document)
    out = StringIO.new
    render_node(document, out)
    out.write "\n" if out.size > 0
    out.string
  end

  def self.render_node(node, out)
    case node
    when Document
      render_document(node, out)
    when Paragraph
      render_paragraph(node, out)
    when Heading
      render_heading(node, out)
    when List
      render_list(node, out)
    when ListItem
      render_list_item(node, out)
    when Text
      render_text(node, out)
    else
      raise "unexpected node: #{node}"
    end
  end

  def self.render_children(node, out)
    node.children.each_with_index do |child, i|
      out.write "\n" if i > 0
      render_node(child, out)
    end
  end

  def self.render_document(node, out)
    render_children(node, out)
  end

  def self.render_paragraph(node, out)
    out.write "<p>"
    render_children(node, out)
    out.write "</p>"
  end

  def self.render_heading(node, out)
    out.write "<h#{node.level}>"
    render_children(node, out)
    out.write "</h#{node.level}>"
  end

  def self.render_list(node, out)
    out.write "<ul>"
    out.write "\n"
    render_children(node, out)
    out.write "\n"
    out.write "</ul>"
  end

  def self.render_list_item(node, out)
    out.write "<li>"
    render_children(node, out)
    out.write "</li>"
  end

  def self.render_text(node, out)
    out.write node.contents
  end
end
