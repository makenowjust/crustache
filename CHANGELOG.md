## v0.3.1 (2015-07-26)

Features:

  - Used `Enumerable` instead of `Array` as model type [`c91d35f`](https://github.com/MakeNowJust/crustache/commit/c91d35f3507e2f93f86e2632abb67f8c21722900)

Changes:

  - Removed `Crustache::Template` type [`ef6931c`](https://github.com/MakeNowJust/crustache/commit/ef6931c71d33ab8a6c841e30087befdb416220d9)
  - Moved `Crustache`'s class methods to some files to fix circular reference [`a507890`](https://github.com/MakeNowJust/crustache/commit/a507890a14bd8c6d466cfd31ce043560f009f938)

## v0.3.0 (2015-07-18)

Features:

  - Added `Crustache::Context` for solving complex model type (see [#1](https://github.com/MakeNowJust/crustache/issues/1)) [`e41a453`](https://github.com/MakeNowJust/crustache/commit/e41a453734164dd3337f325a120f11ee1975832e)
  - Added `Crustache::DEFAULT_FILENAME` [`2d80f1c`](https://github.com/MakeNowJust/crustache/commit/2d80f1c179d21225809579fe8ebd32eaa90cfd20)

Changes:

  - Remove some type restrictions (see [#1](https://github.com/MakeNowJust/crustache/issues/1)) [`0b10d98`](https://github.com/MakeNowJust/crustache/commit/0b10d987a4122607c79593ba305f333de65089cf)
  - Fixed the name of `Crustache.parse_file` from `Crustahce.parseFile` (mismatch naming) [`53dfd00`](https://github.com/MakeNowJust/crustache/commit/53dfd00f4298e9cd9f46b195e1d5e78a3459e2d3)
  - Rename from `src/crustache/tree.cr` to `src/crustache/syntax.cr` [`f860a5a`](https://github.com/MakeNowJust/crustache/commit/f860a5a4d7a194309e38fb026cc12cd5d8941e6a)   
    because `Crustache::Tree` is renamed to `Crustache::Syntax`

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
