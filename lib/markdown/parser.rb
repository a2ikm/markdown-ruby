module Markdown
  class Parser
    def initialize(tokens)
      @tokens = tokens
    end

    def parse
      @pos = 0

      document
    end

    private

    def eof?
      current?(:eof)
    end

    def advance
      @pos += 1
    end

    def current
      @tokens[@pos]
    end

    def peek
      @tokens[@pos+1]
    end

    def peekpeek
      @tokens[@pos+2]
    end

    def type?(token, type)
      token && token.type == type
    end

    def symbol?(token, symbol)
      type?(token, :symbol) && token.literal.start_with?(symbol)
    end

    def consume(type)
      if type?(current, type)
        current.tap { advance }
      end
    end

    def document
      token = current
      blocks = []

      while node = block
        blocks << node
      end

      Node.new(:document, token, blocks: blocks)
    end

    def block
      node = heading
      return node if node

      paragraph
    end

    def heading
      if symbol?(current, "#") && symbol?(peek, " ") && type?(peekpeek, :string)
        hashes = consume(:symbol)
        consume(:symbol)
        string = consume(:string)
        Node.new(:heading, hashes, text: string.literal, level: hashes.literal.length)
      end
    end

    def paragraph
      if token = consume(:string)
        Node.new(:paragraph, token, text: token.literal)
      end
    end
  end
end
