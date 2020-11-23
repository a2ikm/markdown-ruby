module Markdown
  class Lexer
    def initialize(source)
      @source = source
    end

    def lex
      @pos = 0
      @tokens = []

      until eof?
        if newline?(current) && newline?(peek)
          skip_newlines
          next
        end

        if symbol?(current)
          @tokens << read_symbols
          next
        end

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

    def control?(char)
      newline?(char) || symbol?(char)
    end

    def newline?(char)
      char == "\n"
    end

    def symbol?(char)
      ["#", " "].include?(char)
    end

    def skip_newlines
      while newline?(current)
        advance
      end
    end

    def read_symbols
      symbol = current
      start = @pos

      while current == symbol
        advance
      end

      literal = @source[start...@pos]
      Token.new(:symbol, start, literal)
    end

    def read_string
      start = @pos

      while in_string?
        advance
      end

      literal = @source[start...@pos]
      Token.new(:string, start, literal)
    end

    def in_string?
      return false if eof?

      if newline?(current)
        !newline?(peek)
      else
        !symbol?(current)
      end
    end
  end
end
