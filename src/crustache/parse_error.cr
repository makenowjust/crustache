module Crustache
  class ParseError < Exception
    getter filename
    getter row

    def initialize(@msg, @filename, @row); super(message) end

    def message
      "#{@filename.inspect} line at #{@row}: #{@msg}"
    end
  end
end
