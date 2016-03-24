# :nodoc:
class Crustache::Context(T)
  getter parent

  def initialize(@context : T, @parent : Context? = nil); end

  def lookup(key)
    if key == "."
      return @context
    end

    ctx = @context

    keys = key.split(".")
    size = keys.size

    i = 0
    while i < size
      k = keys[i]
      case
      when ctx.responds_to?(:has_key?) && ctx.responds_to?(:[])
        if ctx.has_key?(k)
          ctx = ctx[k]
        else
          break
        end

      else
        break
      end
      i += 1
    end

    if i == size
      return ctx
    end

    if p = @parent
      p.lookup key
    else
      nil
    end
  end
end
