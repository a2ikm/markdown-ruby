require "markdown/version"

module Markdown
  def self.render_html(markdown)
    buffer = []
    blocks = []
    markdown.each_line do |line|
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
      end
    end

    out.string
  end
end
