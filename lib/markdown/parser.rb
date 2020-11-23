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

    def current?(type)
      current && current.type == type
    end

    def consume(type)
      if current?(type)
        current.tap { advance }
      end
    end

    def document
      token = current
      paragraphs = []

      while node = paragraph
        paragraphs << node
      end

      Node.new(:document, token, paragraphs: paragraphs)
    end

    def paragraph
      if token = consume(:string)
        Node.new(:paragraph, token, text: token.literal)
      end
    end
  end
end
