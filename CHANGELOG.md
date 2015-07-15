## v0.2.1 (2015-07-15)

Features:

  - Added `extension` argument for `Crustache::ViewLoader`. It specify filename extensions of implicit loading [`8c69afc`](https://github.com/MakeNowJust/crustache/commit/8c69afc70cf40c6ea93329135d23af1dc4bab7ab)

Changes:

  - Added `spec/spec.cr` for running specs [`db86034`](https://github.com/MakeNowJust/crustache/commit/db86034c49b4bfcd1b793c03b663ebb8f915bcd6)

## v0.2.0 (2015-07-14)

Features:

  - Added `Crustache::Engine`. It is a wrapper class for typical usage [`d813bd2`](https://github.com/MakeNowJust/crustache/commit/d813bd202336f4730cc704e1d607eca8618cb044)
  - Added `Crustache::FileSystem#load!`. It is a strict version `load` [`8a8683b`](https://github.com/MakeNowJust/crustache/commit/8a8683b193a257aa89c8a838d8f3e37037900f6d)

Changes:

  - Now, `Crustache::Renderer` is generic class,
    so you can use many model types in a program [`ee5e258`](https://github.com/MakeNowJust/crustache/commit/ee5e258a54892d679efad03362ae34546c9645f3)
  - Fixed `Crustache.render`'s argument `fs`'s bug [`0f97690`](https://github.com/MakeNowJust/crustache/commit/0f97690c97c35df9cb157b602fb9b999c818449b)

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
