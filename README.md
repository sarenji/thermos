# choco

choco is a templating engine that lets you write HTML templates in
[CoffeeScript](http://coffeescript.org/).

It's a branch of [CoffeeMugg](https://github.com/jaekwon/CoffeeMugg), a branch
of [CoffeeKup](https://github.com/mauricemach/coffeekup).

## Usage

```coffeescript
choco = require 'choco'

choco.render ->
  @doctype 5
  @html ->
    @head ->
      @title "hello"
      @js "main"
    @body ->
      @p "Hello world!"
```

## Extending choco

### Configuration

```configure
choco = require 'choco'

choco.configure
  helpers :
    header_link : (text, url) ->
      @h1 ->
        @link_to text, url

choco.render ->
  @doctype 5
  @html ->
    @head ->
      @title "hello"
      @js "main"
    @body ->
      @header_link "Hello world!", "/"
      @div "#content"
        @p "foobar"
```
    

### Passing options

```coffeescript
choco = require 'choco'

options =
  helpers :
    header_link : (text, url) ->
      @h1 ->
        @link_to text, url

choco.render options, ->
  @doctype 5
  @html ->
    @head ->
      @title "hello"
      @js "main"
    @body ->
      @header_link "Hello world!", "/"
      @div "#content"
        @p "foobar"
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
