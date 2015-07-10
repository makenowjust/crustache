require "./template.cr"

module Crustache
  abstract class FileSystem
    abstract def load(value : String) : Template
  end
end
