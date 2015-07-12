require "./crustache/*"

module Crustache
  # :nodoc:
  OPEN_TAG = "{{".to_slice
  # :nodoc:
  CLOSE_TAG = "}}".to_slice

  def self.parse(string : String, filename = "<inline>", row = 1) : Tree::Template
    self.parse StringIO.new(string), filename, row
  end

  def self.parse(io : IO, filename = "<inline>", row = 1) : Tree::Template
    Parser.new(OPEN_TAG, CLOSE_TAG, io, filename, row).parse
  end

  def self.render(tmpl : Tree::Template, model, fs = FileSystem.new) : String
    String.build do |io|
      self.render tmpl, model, fs, io
    end
  end

  def self.render(tmpl : Tree::Template, model, fs : FileSystem, io : IO)
    tmpl.visit Renderer.new OPEN_TAG, CLOSE_TAG, [model], fs, io
  end
end
