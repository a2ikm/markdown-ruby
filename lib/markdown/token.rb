module Markdown
  class Token
    attr_reader :type, :pos, :literal

    def initialize(type, pos, literal)
      @type = type
      @pos = pos
      @literal = literal
    end
  end
end
