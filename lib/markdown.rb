require "markdown/version"

module Markdown
  def self.render_html(markdown)
    buffer = []
    blocks = []
    markdown.each_line do |line|
      if line == "\n"
        unless buffer.empty?
          blocks << buffer.dup
          buffer.clear
        end
        next
      end

      if line.match?(/\A\#{1,6}\s+.+/)
        unless buffer.empty?
          blocks << buffer.dup
          buffer.clear
        end
        buffer << line
        next
      end

      buffer << line
    end

    unless buffer.empty?
      blocks << buffer.dup
    end

    out = StringIO.new

    blocks.each do |block|
      case block.first
      when /\A(\#{1,6})\s+(.+)/
        out.write "<h#{$1.length}>#{$2}</h#{$1.length}>\n"
      else
        out.write "<p>#{block.join.chomp}</p>\n"
      end
    end

    out.string
  end
end
