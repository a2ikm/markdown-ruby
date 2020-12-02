module Markdown
  class Node
    attr_reader :parent, :children

    def initialize
      @parent = nil
      @children = []
    end

    def append(node)
      children << node
      node.parent = self
      node
    end

    protected def parent=(node)
      @parent = node
    end
  end

  class Document < Node
  end

  class Paragraph < Node
  end

  class Heading < Node
    attr_reader :level

    def initialize(level)
      super()
      @level = level
    end
  end

  class List < Node
    attr_reader :disc

    def initialize(disc)
      super()
      @disc = disc
    end
  end

  class ListItem < Node
  end

  class Text < Node
    attr_reader :contents

    def initialize(contents)
      super()
      @contents = contents
    end
  end
end
