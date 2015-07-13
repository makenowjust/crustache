## v0.2.0 (2015-07-14)

Features:

  - Added `Crustache::Engine`. It is a wrapper class for typical usage. #d813bd20
  - Added `Crustache::FileSystem#load!`. It is a strict version `load`. #8a8683b1

Changes:

  - Now, `Crustache::Renderer` is generic class,
    so you can use many model types in a program. #ee5e258a
  - Fixed `Crustache.render`'s argument `fs`'s bug. #0f97690c

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
