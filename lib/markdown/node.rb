module Markdown
  class Node
    attr_reader :type, :token, :text, :paragraphs

    def initialize(type, token, text: nil, paragraphs: nil)
      @type = type
      @token = token
      @text = text
      @paragraphs = paragraphs
    end
  end
end
