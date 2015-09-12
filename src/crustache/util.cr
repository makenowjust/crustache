# :nodoc:
module Crustache::Util
  # Crystal will remove Slice or Array #length (#1363)
  def self.size(col)
    if col.responds_to?(:length)
      col.length
    else
      col.size
    end
  end
end
