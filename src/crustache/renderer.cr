require "html"
require "./parser.cr"
require "./template.cr"
require "./filesystem.cr"

module Crustache
  alias Context = Nil | Int32 | Int64 | Float64 | String | Bool | Hash(String, Context) | Array(Context) | (String -> String) | (-> String)

  class Renderer
    def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8), @context_stack : Array(Context), @fs : FileSystem, @out_io : IO)
      @open_tag_default = @open_tag
      @close_tag_default = @close_tag
    end

    def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8), context : Context, @fs : FileSystem, @out_io : IO)
      @context_stack = [context] of Context
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
          t = Parser.new(@open_tag_default, @close_tag_default, io, value.to_s).parse
          io.clear
          t.visit(Renderer.new @open_tag_default, @close_tag_default, @context_stack, @fs, io)
          @out_io << HTML.escape io.to_s

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
    end

    def raw(r : Raw)
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
    end

    def partial(p : Partial)
      if part = @fs.load p.value
        part.visit(self)
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

    private def context_scope(ctx : Context, &block)
      @context_stack.unshift ctx
      block.call
      @context_stack.shift
    end

    private def context_lookup(value : String) : Context
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
          when ctx.is_a?(Array(Context))
            if v = val.to_i?
              if 0 <= v && v < ctx.length
                ctx = ctx[v]
              else
                break
              end
            else
              break
            end

          when ctx.is_a?(Hash(String, Context))
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
  end
end
