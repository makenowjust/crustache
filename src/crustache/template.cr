module Crustache
  abstract class Data
    getter delimiter
    setter delimiter

    def initialize; end

    macro inherited
      @[AlwaysInline]
      def visit(v) : Nil
        v.{{ @type.name.gsub(/^.+::/, "").downcase.id }}(self)
        nil
      end
    end
  end

  class Template < Data
    getter content

    def initialize
      @content = [] of Data
    end

    def initialize(@content : Array(Data)); end

    def <<(data : Data)
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
    class {{ type.id }} < Data
      include Tag
    end
  {% end %}

  class Partial < Data
    getter indent
    getter value

    def initialize(@indent : String, @value : String); end
  end

  class Delim < Data
    getter open_tag
    getter close_tag

    def initialize(@open_tag, @close_tag); end
  end
end
