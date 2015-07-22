require "./crustache/*"

module Crustache
  # :nodoc:
  OPEN_TAG = "{{".to_slice
  # :nodoc:
  CLOSE_TAG = "}}".to_slice

  DEFAULT_FILENAME = "__str__"

  def self.parse(io : IO, filename = DEFAULT_FILENAME, row = 1)
    Parser.new(OPEN_TAG, CLOSE_TAG, io, filename, row).parse
  end

  def self.parse(string : String, filename = DEFAULT_FILENAME, row = 1)
    self.parse StringIO.new(string), filename, row
  end

  def self.parse_file(filename)
    self.parse(File.new(filename), filename, 1)
  end

  def self.render(tmpl, model, fs = HashFileSystem.new)
    String.build do |io|
      self.render tmpl, model, fs, io
    end
  end

  def self.render(tmpl, model, fs, io)
    tmpl.visit Renderer.new OPEN_TAG, CLOSE_TAG, Context.new(model), fs, io
  end
end
