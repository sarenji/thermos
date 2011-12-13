@version = '0.0.1'

typeOf = (obj) ->
  Object::toString.call(obj).slice 8, -1

config =
  ROOT_JS_URL : '/javascripts/'
  ROOT_CSS_URL : "/stylesheets/"

@configure = (opts) ->
  config.helpers = opts.helpers

@resetConfig = (opts) ->
  config = {}

@options = options =
  DEFAULT_DOCTYPE : 5

elements =
  # Valid HTML 5 elements requiring a closing tag.
  # Note: the `var` element is out for obvious reasons, please use `tag 'var'`.
  regular: 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp script section
 select small span strong style sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul video'

  # Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_void: 'basefont frame'

for type, tags of elements
  elements[type] = tags.split /\s+/


doctypes =
  '5' : '<!DOCTYPE html>'
  'xml': '<?xml version="1.0" encoding="utf-8" ?>'
  'transitional': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
  'strict': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
  'frameset': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">'
  '1.1': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">',
  'basic': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">'
  'mobile': '<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">'
  'ce': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "ce-html-1.0-transitional.dtd">'


normalizeUrl = (root, url, ext) ->
  url = if url.substr(-ext.length) isnt ext then url + ext else url
  if url[0] is '/' or /^[-a-z]+:\/\//.test url then url else root + url


class ChocoContext
  constructor : (opts={}, template) ->
    if arguments.length is 1
      template = opts
      opts     = {}
    @buffer = []
    @template = template
    @locals = opts.locals or {}
    @[name] = func for name, func of config.helpers or {}
    @[name] = func for name, func of opts.helpers or {}

  for element in elements.regular.concat elements.void
    do (element) =>
      @::[element] = ->
        @tag element, arguments...

  render : (template, opts={}) ->
    @template.call this, @locals
    @buffer.join ''

  doctype : (version=options.DEFAULT_DOCTYPE) ->
    @buffer.push doctypes[String(version)]

  text : (txt) ->
    @buffer.push String(txt)

  js : (url) ->
    url = normalizeUrl(config.ROOT_JS_URL, url, '.js')
    @script type: "text/javascript", src: url

  css : (url) ->
    url = normalizeUrl(config.ROOT_CSS_URL, url, '.css')
    @link type: "text/css", rel: "stylesheet", media: "screen", href: url

  tag : (tagName, args...) ->
    for arg in args
      switch typeOf arg
        when 'Function'
          func = arg
        when 'String'
          text = arg
        when 'Object'
          attrs = arg
          if data = attrs.data
            delete attrs.data
            for key, val of data
              key = key.replace /_/g, '-'
              attrs["data-#{key}"] = val

    attrs or= {}
    attrs = (" #{key}=\"#{value}\"" for key, value of attrs).join ''

    if tagName in elements.void
      @text "<#{tagName}#{attrs}/>"
    else
      @text "<#{tagName}#{attrs}>"
      @text func.call this if func?
      @text text           if text?
      @text "</#{tagName}>"
    ""

@render = (opts={}, template) ->
  cc = new ChocoContext(opts, template)
  cc.render()
