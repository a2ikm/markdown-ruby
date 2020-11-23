require "markdown/version"
require "markdown/token"
require "markdown/node"
require "markdown/lexer"
require "markdown/parser"
require "markdown/renderer"

module Markdown
  def self.render_html(markdown)
    tokens = Lexer.new(markdown).lex
    nodes = Parser.new(tokens).parse
    Renderer.new(nodes).render_html
  end
end
