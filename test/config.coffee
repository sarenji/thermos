should = require 'should'
thermos  = require '../src/thermos'

test = (args) ->
  ->
    {render, output, opts, beforeRender} = args
    if beforeRender then beforeRender()
    thermos.render(opts, render).should.equal output

describe "the default @js helper", ->
  it 'works with relative paths', test
    render : ->
      @js 'main.min'
    output :
      '<script type="text/javascript" src="/javascripts/main.min.js"></script>'

  it 'works with relative paths, with .js', test
    render : ->
      @js 'slideshow/main.js'
    output :
      '<script type="text/javascript" src="/javascripts/slideshow/main.js"></script>'

  it 'works with absolute paths', test
    render : ->
      @js '/main'
    output :
      '<script type="text/javascript" src="/main.js"></script>'

  it 'works with absolute paths with .js', test
    render : ->
      @js '/slideshow/main.js'
    output :
      '<script type="text/javascript" src="/slideshow/main.js"></script>'

  it 'works with paths on another domain', test
    render : ->
      @js 'http://example.com/test'
    output :
      '<script type="text/javascript" src="http://example.com/test.js"></script>'

  it 'works with paths on another domain with .js', test
    render : ->
      @js '//example.com/test.js'
    output :
      '<script type="text/javascript" src="//example.com/test.js"></script>'

describe 'the default @css helper', ->
  it 'works with relative paths', test
    render : ->
      @css 'main'
    output : '<link type="text/css" rel="stylesheet" media="screen" href="/stylesheets/main.css"/>'
  # all other ways work as well since @css uses the same internal helper as @js

describe 'the default @link_to helper', ->
  describe 'with one argument', ->
    it 'links to the url with the text as the url', test
      render : ->
        @link_to 'http://example.com'
      output : '<a href="http://example.com">http://example.com</a>'
  describe 'with two arguments', ->
    it "uses first arg as text, second arg as href", test
      render : ->
        @link_to 'click here', 'rickroll'
      output : '<a href="rickroll">click here</a>'

    it "accepts absolute links", test
      render : ->
        @link_to 'click here', '/about'
      output : '<a href="/about">click here</a>'

    it "accepts other domain links", test
      render : ->
        @link_to 'click here', 'http://example.com'
      output : '<a href="http://example.com">click here</a>'

    it 'can take a link and a func', test
      render : ->
        @link_to '#', ->
          @span 'hey'
      output : '<a href="#"><span>hey</span></a>'

  describe 'with three arguments', ->
    it 'uses the third as attrs, if it\'s a hash', test
      render : ->
        @link_to 'click here', '#', class: 'big'
      output : '<a href="#" class="big">click here</a>'

    it 'can take an url, attrs, and func', test
      render : ->
        @link_to '#', class: 'big', ->
          @span 'click here'
      output : '<a href="#" class="big"><span>click here</span></a>'

describe 'a helper function', ->
  helper_helper = (url) -> "#{url}.js"

  it "gets included", test
    render : ->
      @js2 'hullo'
    opts:
      helpers :
        js2 : (url) ->
          @script type: 'text/javascript', src: helper_helper(url)
    output : '<script type="text/javascript" src="hullo.js"></script>'

describe 'a configuration', ->
  # Append the `ext` to `url` if the url doesn't have particular `ext`
  helper_helper = (url, ext) ->
    if url.substr(-ext.length) isnt ext then "#{url}#{ext}" else url

  beforeEach ->
    thermos.configure
      helpers :
        js2 : (url) ->
          @script type: 'text/javascript', src: helper_helper(url, '.js')

  afterEach ->
    thermos.resetConfig()

  it "gets included", test
    render : ->
      @head ->
        @js2 'main'
        @css2 'style'
    opts:
      helpers :
        css2 : (url) ->
          @link rel: 'text/stylesheet', href: helper_helper(url, '.css')
    output : '<head><script type="text/javascript" src="main.js"></script><link rel="text/stylesheet" href="style.css"/></head>'

  
  it "can be modified multiple times", test
    beforeRender: ->
      thermos.configure
        helpers: 
          chicken: () -> @text 'chicken'
          dance: () -> @text 'dance'
      thermos.configure
        helpers: 
          dance: () -> ' cucko cucko cuck cuck ooo'
    render: ->
      @span ->
        @chicken()
        @dance()
    output: '<span>chicken cucko cucko cuck cuck ooo</span>'