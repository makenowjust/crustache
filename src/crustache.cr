require "./crustache/*"

module Crustache
  OPEN_TAG = "{{".to_slice
  CLOSE_TAG = "}}".to_slice

  def self.parse(string : String, filename = "<inline>", row = 1)
    self.parse StringIO.new(string), filename, row
  end

  def self.parse(io : IO, filename = "<inline>", row = 1)
    Parser.new(OPEN_TAG, CLOSE_TAG, io, filename, row).parse
  end

  def self.render(tmpl : Template, ctx : Context, fs = FileSystem.new)
    String.build do |io|
      self.render tmpl, ctx, fs, io
    end
  end

  def self.render(tmpl : Template, ctx : Context, fs : FileSystem, io : IO)
    tmpl.visit Renderer.new OPEN_TAG, CLOSE_TAG, [ctx] of Context, fs, io
  end
end
