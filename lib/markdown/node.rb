module Markdown
  class Node
    attr_reader :type, :token, :text, :level, :blocks

    def initialize(type, token, text: nil, level: nil, blocks: nil)
      @type = type
      @token = token
      @text = text
      @level = level
      @blocks = blocks
    end
  end
end
