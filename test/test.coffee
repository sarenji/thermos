should = require 'should'
choco  = require '../src/choco'

test = (args) ->
  ->
    {render, output, opts} = args
    choco.render(opts, render).should.equal output

describe "pure text", ->
  it "renders correctly", test
    render : ->
      @text 'hello'
    output : 'hello'

describe "a default doctype", ->
  it "renders correctly", test
    render : ->
      @doctype()
    output : '<!DOCTYPE html>'

describe "a given doctype", ->
  it "renders correctly", test
    render : ->
      @doctype 'strict'
    output : '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'

describe 'a custom tag', ->
  it "renders correctly", test
    render : ->
      @tag 'takeover'
    output : '<takeover></takeover>'

describe 'a custom tag with attributes', ->
  it "renders correctly", test
    render : ->
      @tag 'takeover', the: "world", gwoh: "hoho"
    output : '<takeover the="world" gwoh="hoho"></takeover>'

describe 'a custom tag with attributes and text', ->
  it "renders correctly", test
    render : ->
      @tag 'takeover', the: "world", "-- Brain"
    output : '<takeover the="world">-- Brain</takeover>'

describe 'a custom tag with attributes and a text function', ->
  it "renders correctly", test
    render : ->
      @tag 'takeover', the: "world", -> "-- Brain"
    output : '<takeover the="world">-- Brain</takeover>'

describe 'a self-closing tag', ->
  it "renders correctly", test
    render : ->
      @img src: "foo.png", alt: "bar"
    output : '<img src="foo.png" alt="bar"/>'

describe 'a paragraph tag', ->
  it "renders correctly", test
    render : ->
      @p "Excellent."
    output : '<p>Excellent.</p>'

describe 'a paragraph tag with attrs', ->
  it "renders correctly", test
    render : ->
      @p class: "left", "Excellent."
    output : '<p class="left">Excellent.</p>'

  it "dasherizes data attrs", test
    render : ->
      @span data : {foo : "bar"}, "Dasherized!"
    output : '<span data-foo="bar">Dasherized!</span>'

describe 'a local variable', ->
  it "gets included", test
    render : (locals) ->
      @p class: "left", -> @locals.name
      @p locals.email
    opts:
      locals :
        name  : "Bob"
        email : "bob@example.com"
    output : '<p class="left">Bob</p><p>bob@example.com</p>'

describe 'a basic template', ->
  it "renders correctly", test
    render : ->
      @doctype 5
      @html ->
        @head ->
          @title "hello"
        @body ->
          @p "Hello world!"
    output : '<!DOCTYPE html><html><head><title>hello</title></head><body><p>Hello world!</p></body></html>'

describe 'a helper function', ->
  helper_helper = (url) ->
    "#{url}.js"

  it "gets included", test
    render : ->
      @js 'hullo'
    opts:
      helpers :
        js : (url) ->
          @script type: 'text/javascript', src: helper_helper(url)
    output : '<script type="text/javascript" src="hullo.js"></script>'