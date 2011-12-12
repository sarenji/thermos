# choco

choco is a templating engine that lets you write HTML templates in
[CoffeeScript](http://coffeescript.org/).

It's a branch of [CoffeeMugg](https://github.com/jaekwon/CoffeeMugg), a branch
of [CoffeeKup](https://github.com/mauricemach/coffeekup).

## Usage

```
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

## Why choco?

CoffeeKup breaks closures. CoffeeMugg requires some semi-clunky code to extend
the language.

## Test

choco uses mocha for testing.

```
$ npm install
$ mocha
```

## Thanks

[jaekwon](https://github.com/jaekwon), for CoffeeMugg.  
[mauricemach](https://github.com/mauricemach), for CoffeeKup.

Don't kill me, both.
