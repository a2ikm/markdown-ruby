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

    while line = e.next rescue nil
      line.strip!

      if line.empty?
        if current
          current = nil
        end
        next
      elsif m = line.match(/(\A\#{1,6})\s+(.+)/)
        heading = Heading.new(m[1].length)
        heading.append(Text.new(m[2]))
        document.append(heading)
        current = nil
      elsif m = line.match(/([-+*])\s+(.+)/)
        if current.instance_of?(ListItem) && current.parent.disc == m[1]
          list_item = ListItem.new
          list_item.append(Text.new(m[2]))
          current.parent.append(list_item)
          current = list_item
        else
          list = List.new(m[1])
          document.append(list)
          list_item = ListItem.new
          list_item.append(Text.new(m[2]))
          list.append(list_item)
          current = list_item
        end
      elsif current
        current.append(Text.new(line))
      else
        paragraph = Paragraph.new
        paragraph.append(Text.new(line))
        document.append(paragraph)
        current = paragraph
      end
    end
  end

  def self.render(document)
    out = StringIO.new
    render_node(document, out)
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
    else
      raise "unexpected node: #{node}"
    end
  end

  def self.render_document(node, out)
    node.children.each do |child|
      render_node(child, out)
    end
  end

  def self.render_paragraph(node, out)
    out.write "<p>"
    out.write render_texts(node.children)
    out.write "</p>\n"
  end

  def self.render_heading(node, out)
    out.write "<h#{node.level}>"
    out.write render_texts(node.children)
    out.write "</h#{node.level}>\n"
  end

  def self.render_list(node, out)
    out.write "<ul>\n"
    node.children.each do |child|
      render_node(child, out)
    end
    out.write "</ul>\n"
  end

  def self.render_list_item(node, out)
    out.write "<li>"
    out.write render_texts(node.children)
    out.write "</li>\n"
  end

  def self.render_texts(texts)
    texts.map(&:contents).join("\n")
  end
end
