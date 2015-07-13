require "./tree.cr"

module Crustache
  abstract class FileSystem
    abstract def load(value : String) : Tree::Template?

    def load!(value : String) : Tree::Template
      if tmpl = self.load value
        return tmpl
      else
        raise "#{value} is not found"
      end
    end
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

  class ViewLoader < FileSystem
    def initialize(@basedir : String, @use_cache = false)
      @cache = {} of String => Tree::Template?
    end

    def load(value)
      if @cache.has_key?(value)
        return @cache[value]
      end

      filename = "#{@basedir}/#{value}"
      filename_ext = "#{filename}.mustache"
      if File.exists?(filename_ext)
        tmpl = Crustache.parseFile filename_ext
        @cache[value] = tmpl if @use_cache
        return tmpl
      end

      if File.exists?(filename)
        tmpl = Crustache.parse filename
        @cache[value] = tmpl if @use_cache
        return tmpl
      end

      @cache[value] = nil if @use_cache
      return nil
    end
  end
end
