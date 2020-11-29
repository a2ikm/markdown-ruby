require "markdown/version"

module Markdown
  def self.render_html(markdown)
    buffer = []
    blocks = []
    e = markdown.each_line

    while line = e.next rescue nil
      if line == "\n"
        unless buffer.empty?
          blocks << [:p, nil, buffer.dup]
          buffer.clear
        end
        next
      end

      if m = line.match(/\A(\#{1,6})\s+(.+)/)
        unless buffer.empty?
          blocks << [:p, nil, buffer.dup]
          buffer.clear
        end
        blocks << [:h, { level: m[1].length }, [m[2]]]
        next
      end

      if m = line.match(/\A-\s+(.+)/)
        list = []
        list << m[1]
        while m = e.peek.match(/\A-\s+(.+)/) rescue nil
          list << m[1]
          e.next
        end
        blocks << [:ul, nil, list]
        next
      end

      buffer << line
    end

    unless buffer.empty?
      blocks << [:p, nil, buffer.dup]
      buffer.clear
    end

    out = StringIO.new

    blocks.each do |(type, opts, lines)|
      case type
      when :h
        tag = "h#{opts[:level]}"
        out.write "<#{tag}>#{lines.join.chomp}</#{tag}>\n"
      when :p
        out.write "<p>#{lines.join.chomp}</p>\n"
      when :ul
        out.write "<ul>\n"
        lines.each do |line|
          out.write "<li>#{line.chomp}</li>\n"
        end
        out.write "</ul>\n"
      end
    end

    out.string
  end
end
