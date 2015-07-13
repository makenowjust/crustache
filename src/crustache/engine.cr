module Crustache
  class Engine
    def initialize(@basedir : String, @cache = false)
      self.initialize ViewLoader.new @basedir, @cache
    end

    def initialize(@fs : FileSystem); end

    # It renders a template loaded from `filename` with `model`
    # and it returns rendered string.
    # If `filename` is not found, it returns `nil`, but it dosen't raise an error.
    def render(filename : String, model)
      @fs.load(filename).try{|tmpl| self.render tmpl, model}
    end

    def render(filename : String, model, output : IO)
      @fs.load(filename).try{|tmpl| self.render tmpl, model, output}
    end

    # It is a strict version `Engine#render`.
    # If `filename` is not found, it raise an error.
    def render!(filename : String, model)
      @fs.load!(filename).try{|tmpl| self.render tmpl, model}
    end

    def render!(filename : String, model, output : IO)
      @fs.load!(filename).try{|tmpl| self.render tmpl, model, output}
    end

    def render(tmpl : Template, model)
      Crustache.render tmpl, model, @fs
    end

    def render(tmpl : Template, model, output : IO)
      Crustache.render tmpl, model, @fs, io
    end
  end
end
