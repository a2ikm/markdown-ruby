require "markdown/version"

module Markdown
  def self.render_html(markdown)
    out = StringIO.new

    buffer = []
    markdown.each_line do |line|
      if line == "\n"
        unless buffer.empty?
          out.write "<p>#{buffer.join.chomp}</p>\n"
          buffer.clear
        end
        next
      end

      buffer << line
    end

    unless buffer.empty?
      out.write "<p>#{buffer.join.chomp}</p>\n"
    end

    out.string
  end
end
