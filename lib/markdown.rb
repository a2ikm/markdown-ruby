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

    document.children.each do |node|
      case node
      when Paragraph
        out.write "<p>"
        out.write render_texts(node.children)
        out.write "</p>\n"
      when Heading
        out.write "<h#{node.level}>"
        out.write render_texts(node.children)
        out.write "</h#{node.level}>\n"
      when List
        out.write "<ul>\n"
        node.children.each do |item|
          out.write "<li>"
          out.write render_texts(item.children)
          out.write "</li>\n"
        end
        out.write "</ul>\n"
      else
        raise "unexpected node: #{node}"
      end
    end

    out.string
  end

  def self.render_texts(texts)
    texts.map(&:contents).join("\n")
  end
end
