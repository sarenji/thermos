# thermos [![Build Status](https://secure.travis-ci.org/sarenji/thermos.png?branch=master)](http://travis-ci.org/sarenji/thermos)

thermos is a templating engine that lets you write HTML templates in
[CoffeeScript](http://coffeescript.org/).

It's a branch of [CoffeeMugg](https://github.com/jaekwon/CoffeeMugg), a branch
of [CoffeeKup](https://github.com/mauricemach/coffeekup).

## Usage

```coffeescript
thermos = require 'thermos'

thermos.render ->
  @doctype 5
  @html ->
    @head ->
      @title "hello"
      @js "main"
    @body ->
      @p "Hello world!"
```

### HTML entities

HTML entities are automatically encoded for you. Writing this:

```coffeescript
thermos.render ->
  @h1 ->
    @span '<b>—&</b>"\'&mdash;hi'
```

will produce `<h1><span>&gt;b&lt;&mdash;&amp;&gt;/b&lt;&quot;&apos;&mdash;hi</span></h1>`

You can use `@html_safe` to prevent Thermos from auto-encoding entities for you. For example, `@span @html_safe '<b>—&</b>"\''` will output `<h1><span><b>—&</b>"\'</span></h1>`.

## Extending thermos

### Configuration

```coffeescript
thermos = require 'thermos'

thermos.configure
  helpers :
    header_link : (text, url) ->
      @h1 ->
        @link_to text, url

thermos.render ->
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
thermos = require 'thermos'

options =
  helpers :
    header_link : (text, url) ->
      @h1 ->
        @link_to text, url

thermos.render options, ->
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

Currently, thermos includes `@js`, `@css`, and `@link_to` helpers by default.

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

## Why thermos?

CoffeeKup breaks closures. Extending CoffeeMugg isn't as nice as I'd like.

## Test

thermos uses mocha for running tests.

```bash
$ npm install
$ mocha
```

## Installation

```bash
$ npm install thermos
```

## Thanks to

[jaekwon](https://github.com/jaekwon), for CoffeeMugg.
[mauricemach](https://github.com/mauricemach), for CoffeeKup.

Don't kill me, both.
