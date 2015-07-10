require "./template.cr"

module Crustache
  class FileSystem
    def initialize
      @tmpls = {} of String => Template
    end

    def register(name, tmpl)
      @tmpls[name] = tmpl
    end

    def load(value)
      return @tmpls[value]?
    end
  end
end
