# choco

choco is a templating engine that lets you write HTML templates in
[CoffeeScript](http://coffeescript.org/).

It's a branch of [CoffeeMugg](https://github.com/jaekwon/CoffeeMugg), a branch
of [CoffeeKup](https://github.com/mauricemach/coffeekup).

## Usage

```coffeescript
choco = require 'choco'

normalizeUrl = (url, ext) ->
  if url.substr(-ext.length) isnt ext then "#{url}#{ext}" else url

options =
  helpers =
    js : (url) ->
      url = normalizeUrl(url, '.js')
      @script src: url, type: 'text/javascript'

choco.render options, ->
  @doctype 5
  @html ->
    @head ->
      @title "hello"
      @js "main"
    @body ->
      @p "Hello world!"
```

## Default helpers

Currently, choco includes `@js`, `@css`, and `@link_to` helpers by default.

```coffeescript
@link_to text, url
@js url
@css url

@link_to "click here", "#anchor"
@link_to "click here", "http://example.com"
@link_to "click here", "/about"

@js "jquery"
@js "jquery.min"
@js "jquery.min.js"
@js "/vendor/jquery.min"
@js "/vendor/jquery.min.js"
@js "http://example.com/jquery"
@js "http://example.com/jquery.js"

@css "main"
@css "main.css"
# same as @js
```

## Why choco?

CoffeeKup breaks closures. Extending CoffeeMugg isn't as nice as I'd like.

## Test

choco uses mocha for running tests.

```bash
$ npm install
$ mocha
```

## Installation

```bash
$ npm install choco
```

## Thanks to

[jaekwon](https://github.com/jaekwon), for CoffeeMugg.
[mauricemach](https://github.com/mauricemach), for CoffeeKup.

Don't kill me, both.
