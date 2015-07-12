require "html"
require "./parser.cr"
require "./template.cr"
require "./filesystem.cr"

module Crustache
  # :nodoc:
  class Renderer
    def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8), @context_stack : Array, @fs : FileSystem, @out_io : IO)
      @open_tag_default = @open_tag
      @close_tag_default = @close_tag
    end

    def template(t : Template)
      t.content.each &.visit(self)
    end

    def section(s : Section)
      if value = context_lookup s.value
        case
        when value.is_a?(Array)
          value.each do |ctx|
            context_scope ctx do
              s.content.each &.visit(self)
            end
          end

        when value.is_a?(String -> String)
          io = StringIO.new
          t = Template.new s.content
          t.visit Stringify.new @open_tag, @close_tag, io
          io = StringIO.new value.call io.to_s
          t = Parser.new(@open_tag, @close_tag, io, value.to_s).parse
          io.clear
          t.visit(Renderer.new @open_tag, @close_tag, @context_stack, @fs, io)
          @out_io << io.to_s

        else
          context_scope value do
            s.content.each &.visit(self)
          end
        end
      end
    end

    def invert(i : Invert)
      if value = context_lookup i.value
        if value.is_a?(Array)
          i.content.each(&.visit(self)) if value.empty?
        end
      else
        i.content.each &.visit(self)
      end
    end

    def output(o : Output)
      (@out_io as IndentIO).indent_flag_off if @out_io.is_a?(IndentIO)
      if value = context_lookup o.value
        if value.is_a?(-> String)
          io = StringIO.new value.call
          t = Parser.new(@open_tag_default, @close_tag_default, io, value.to_s).parse
          io.clear
          t.visit(Renderer.new @open_tag_default, @close_tag_default, @context_stack, @fs, io)
          @out_io << HTML.escape io.to_s
        else
          @out_io << HTML.escape value.to_s
        end
      end
      (@out_io as IndentIO).indent_flag_on if @out_io.is_a?(IndentIO)
    end

    def raw(r : Raw)
      (@out_io as IndentIO).indent_flag_off if @out_io.is_a?(IndentIO)
      if value = context_lookup r.value
        if value.is_a?(-> String)
          io = StringIO.new value.call
          t = Parser.new(@open_tag_default, @close_tag_default, io, value.to_s).parse
          io.clear
          t.visit(Renderer.new @open_tag_default, @close_tag_default, @context_stack, @fs, io)
          @out_io << io.to_s
        else
          @out_io << value.to_s
        end
      end
      (@out_io as IndentIO).indent_flag_on if @out_io.is_a?(IndentIO)
    end

    def partial(p : Partial)
      if part = @fs.load p.value
        part.visit(Renderer.new @open_tag_default, @close_tag_default, @context_stack, @fs, IndentIO.new(p.indent, @out_io))
      end
    end

    def comment(c : Comment); end

    def text(t : Text)
      @out_io << t.value
    end

    def delim(d : Delim)
      @open_tag = d.open_tag
      @close_tag = d.close_tag
    end

    private def context_scope(ctx, &block)
      @context_stack.unshift ctx
      block.call
      @context_stack.shift
    end

    private def context_lookup(value : String)
      if value == "."
        return @context_stack[0]
      end

      vals = value.split(".")
      len = vals.length

      @context_stack.each do |ctx|
        i = 0
        while i < len
          val = vals[i]
          case
          when ctx.is_a?(Array)
            if v = val.to_i?
              if 0 <= v && v < ctx.length
                ctx = ctx[v]
              else
                break
              end
            else
              break
            end

          when ctx.responds_to?(:has_key?) && ctx.responds_to?(:[])
            if ctx.has_key?(val)
              ctx = ctx[val]
            else
              break
            end

          else
            break
          end
          i += 1
        end

        if i == len
          return ctx
        end
      end

      nil
    end

    class IndentIO
      include IO

      def initialize(@indent : String, @io : IO)
        @indent_flag = 0
        @eol_flag = true
      end

      def indent_flag_on
        @indent_flag -= 1
      end

      def indent_flag_off
        @indent_flag += 1
      end

      def write(s : Slice(UInt8), len)
        start = 0
        i = 0
        while i < len
          if @eol_flag
            @io.write (s + start), (i - start)
            @io << @indent
            @eol_flag = false
            start = i
          end

          if s[i] == Parser::NEWLINE_N && @indent_flag == 0
            @eol_flag = true
          end

          i += 1
        end

        @io.write (s + start), (i - start)
      end
    end
  end
end
