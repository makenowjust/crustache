## v0.2.0 (2015-07-14)

Features:

  - Added `Crustache::Engine`. It is a wrapper class for typical usage. (d813bd202336f4730cc704e1d607eca8618cb044)
  - Added `Crustache::FileSystem#load!`. It is a strict version `load`. (8a8683b193a257aa89c8a838d8f3e37037900f6d)

Changes:

  - Now, `Crustache::Renderer` is generic class,
    so you can use many model types in a program. (ee5e258a54892d679efad03362ae34546c9645f3)
  - Fixed `Crustache.render`'s argument `fs`'s bug. (0f97690c97c35df9cb157b602fb9b999c818449b)

## v0.1.1 (2015-07-12)

Features:

  - Added `Crustache::ViewLoader`
  - Added `Crustache.parseFile`

Changes:

  - Move `Crustache::Data` and this subclasses under `Crustache::Tree`

## v0.1.0 (2015-07-12)

Features:

  - Added implementation of Mustache v1.1.2+λ
  - Added support flexible contexts (but type is complex!)
