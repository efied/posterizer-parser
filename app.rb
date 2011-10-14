require File.join(File.dirname(__FILE__), 'lib', 'posterous-parser.rb')

template = File.read(File.join('public', 'index.html'))
rendered_html = PosterousParser.parse(template)
puts rendered_html


