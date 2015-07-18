module Crustache::Syntax
  abstract class Node
    def initialize; end

    macro inherited
      @[AlwaysInline]
      def visit(v) : Nil
        v.{{ @type.name.gsub(/^.+::/, "").downcase.id }}(self)
        nil
      end
    end
  end

  class Template < Node
    getter content

    def initialize
      @content = [] of Node
    end

    def initialize(@content); end

    def <<(data)
      unless data.is_a?(Text) && data.value.empty?
        @content << data
      end
      self
    end
  end

  module Tag
    getter value

    def initialize(@value : String); super() end
  end

  {% for type in %w(Section Invert) %}
    class {{ type.id }} < Template
      include Tag
    end
  {% end %}

  {% for type in %w(Output Raw Comment Text) %}
    class {{ type.id }} < Node
      include Tag
    end
  {% end %}

  class Partial < Node
    getter indent
    getter value

    def initialize(@indent, @value); end
  end

  class Delim < Node
    getter open_tag
    getter close_tag

    def initialize(@open_tag, @close_tag); end
  end
end
