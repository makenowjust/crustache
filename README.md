# crustache

crustache is the implementation of __[mustache](https://mustache.github.io/)__ logic-less templates.

This library implemated [mustache's spec v1.1.2+λ](https://github.com/mustache/spec/tree/v1.1.2).

[![travis-ci.org](https://img.shields.io/travis/MakeNowJust/crustache.svg?style=flat-square)](https://travis-ci.org/MakeNowJust/crustache)
[![docrystal.org](http://www.docrystal.org/badge.svg)](http://www.docrystal.org/github.com/MakeNowJust/crustache)
[![gratipay.com](https://img.shields.io/gratipay/MakeNowJust.svg?style=flat-square)](https://gratipay.com/MakeNowJust)
[![flattr.com](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=make_now_just&url=https%3A%2F%2Fgithub.com%2FMakeNowJust%2Fcrustache)

```text
                        __             __
  ____________  _______/ /_____ ______/ /_  ___
 / ___/ ___/ / / / ___/ __/ __ `/ ___/ __ \/ _ \
/ /__/ /  / /_/ (__  ) /_/ /_/ / /__/ / / /  __/
\___/_/   \__,_/____/\__/\__,_/\___/_/ /_/\___/
```

## Installation

Add it to `Projectfile`

```crystal
deps do
  github "MakeNowJust/crustache"
end
```

## Usage

```crystal
require "crustache"

# Parse a mustache template
template = Crustache.parse "Hello {{Name}} World!"

# Make a model
model = {"Name" => "Crustache"}

# Render!
puts Crustache.render template, model
#=> Hello Crustache World!
```

## Development

This library's specs are put in `spec` directory. They can run by `crystal spec ./spec/spec.cr` command.

## Contributing

1. Fork it ([https://github.com/MakeNowJust/crustache/fork](https://github.com/MakeNowJust/crustache/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer
