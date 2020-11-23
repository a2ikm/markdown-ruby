module Markdown
  class Node
    attr_reader :type, :token, :text

    def initialize(type, token, text: nil)
      @type = type
      @token = token
      @text = text
    end
  end
end
