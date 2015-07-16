require "./tree.cr"

module Crustache
  module FileSystem
    def load!(value)
      if tmpl = self.load value
        return tmpl
      else
        raise "#{value} is not found"
      end
    end
  end

  class HashFileSystem
    include FileSystem

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

  class ViewLoader
    include FileSystem

    EXTENSION = [".mustache", ".html", ""]

    def initialize(@basedir, @use_cache = false, @extension = EXTENSION)
      @cache = {} of String => Template?
    end

    def load(value)
      if @cache.has_key?(value)
        return @cache[value]
      end

      @extension.each do |ext|
        filename = "#{@basedir}/#{value}"
        filename_ext = "#{filename}#{ext}"
        if File.exists?(filename_ext)
          tmpl = Crustache.parseFile filename_ext
          @cache[value] = tmpl if @use_cache
          return tmpl
        end
      end

      @cache[value] = nil if @use_cache
      return nil
    end
  end
end
