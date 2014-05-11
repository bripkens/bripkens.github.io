require 'date'

module Jekyll
  class Now < Liquid::Tag
    safe = true
    
    def render(context)
      DateTime.now
    end
  end
end

Liquid::Template.register_tag('now', Jekyll::Now)