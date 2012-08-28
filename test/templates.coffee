should = require 'should'
thermos  = require '../src/thermos'

test = (args) ->
  ->
    {render, output, opts} = args
    thermos.render(opts, render).should.equal output

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

  describe 'with attributes', ->
    it "renders correctly", test
      render : ->
        @tag 'takeover', the: "world", gwoh: "hoho"
      output : '<takeover the="world" gwoh="hoho"></takeover>'

    describe 'and text', ->
      it "renders correctly", test
        render : ->
          @tag 'takeover', the: "world", "-- Brain"
        output : '<takeover the="world">-- Brain</takeover>'

    describe 'and a text function', ->
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

  it "renders correctly with a blank func", test
    render : ->
      @p ->
    output : '<p></p>'

  describe 'with attrs', ->
    it "renders correctly", test
      render : ->
        @p class: "left", "Excellent."
      output : '<p class="left">Excellent.</p>'

    it "dasherizes data attrs", test
      render : ->
        @span data : {foo_bar_fo : "camp"}, "Dasherized!"
      output : '<span data-foo-bar-fo="camp">Dasherized!</span>'

describe 'id and classes', ->
  it "should be in the first argument", test
    render : ->
      @p "#test"
    output : '<p id="test"></p>'

  it "should support just a class", test
    render : ->
      @p ".test"
    output : '<p class="test"></p>'

  it "should work with other input", test
    render : ->
      @p "#test.a", bogus : "bogus", "hi"
    output : '<p id="test" class="a" bogus="bogus">hi</p>'

  it "should work reversed", test
    render : ->
      @p ".a#test", "hi"
    output : '<p id="test" class="a">hi</p>'

  it 'takes only the first id arg', test
    render : ->
      @p "#use_this-really#not_this"
    output : '<p id="use_this-really"></p>'

  it "are space-separated", test
    render : ->
      @p ".a.b", "hi"
    output : '<p class="a b">hi</p>'

  it "aren't activated by a space in a string", test
    render : ->
      @p "#hello .a.b"
    output : '<p>#hello .a.b</p>'

  it "aren't activated by an non-alphabetic letter after identifiers", test
    render : ->
      @p "#!hello.*a"
    output : '<p>#!hello.*a</p>'

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

  inner = (locals) -> locals.name
  it 'gets passed to inner functions with a different closure', test
    render: (locals) ->
      @p inner
    opts:
      locals :
        name : "Bob"
    output : '<p>Bob</p>'

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

describe 'the template function', ->
  it 'renders correctly when called', ->
    template = thermos.template ({arg1, arg2}) ->
      @p arg1
      @p arg2
    template(
      arg1: 'one'
      arg2: 'two'
    ).should.equal '<p>one</p><p>two</p>'

describe 'a for loop', ->
  it 'renders correctly', test
    render : ->
      @div ->
        for number in [1..3]
          @p "" + number
    output : '<div><p>1</p><p>2</p><p>3</p></div>'

describe "html", ->
  it "gets encoded correctly", test
    render : ->
      @h1 ->
        @span '<b>—&</b>"\'&mdash;hi'
    output : "<h1><span>&gt;b&lt;&mdash;&amp;&gt;/b&lt;&quot;&apos;&mdash;hi</span></h1>"

  it "gets left alone if the string is modified to be html safe", test
    render : ->
      @h1 ->
        @span @html_safe '<b>—&</b>"\''
    output : '<h1><span><b>—&</b>"\'</span></h1>'

describe 'a script tag', ->
  it "can take a function with coffeescript in it", test
    render: ->
      @script ->
        # Based off the socket.io docs
        socket = io.connect 'http://localhost'
        socket.on 'news', (data) ->
          console.log data
          socket.emit 'my other event', my: 'data'
    output : """
    <script>(function () {
              var socket;
              socket = io.connect(\'http://localhost\');
              return socket.on(\'news\', function(data) {
                console.log(data);
                return socket.emit(\'my other event\', {
                  my: \'data\'
                });
              });
            }).call(this);</script>
    """
