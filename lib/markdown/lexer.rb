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

    def newline?(char)
      char == "\n"
    end

    def skip_newlines
      while newline?(current)
        advance
      end
    end

    def read_string
      start = @pos

      while !eof? && (!newline?(current) || (newline?(current) && !newline?(peek)))
        advance
      end

      literal = @source[start...@pos]
      Token.new(:string, start, literal)
    end
  end
end
