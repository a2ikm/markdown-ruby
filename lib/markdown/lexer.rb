module Markdown
  class Lexer
    def initialize(source)
      @source = source
    end

    def lex
      @pos = 0
      @tokens = []

      until eof?
        @tokens << read_string
      end

      @tokens << Token.new(:eof, @pos, nil)
      @tokens
    end

    private

    def eof?
      @pos >= @source.length
    end

    def advance
      @pos += 1
    end

    def current
      @source[@pos]
    end

    def peek
      @source[@pos+1]
    end

    def string?(char)
      !eof?
    end

    def read_string
      start = @pos

      while string?(current)
        advance
      end

      literal = @source[start..@pos]
      Token.new(:string, start, literal).tap { advance }
    end
  end
end
