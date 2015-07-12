require "./tree.cr"

module Crustache
  abstract class FileSystem
    abstract def load(value : String) : Tree::Template?
  end

  class HashFileSystem < FileSystem
    def initialize
      @tmpls = {} of String => Tree::Template
    end

    def register(name, tmpl)
      @tmpls[name] = tmpl
    end

    def load(value)
      return @tmpls[value]?
    end
  end
end
