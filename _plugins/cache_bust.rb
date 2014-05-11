require 'date'

module Jekyll
  class CacheBust < Liquid::Tag
    safe = true
    
    def render(context)
      Time.now.to_i.to_s
    end
  end
end

Liquid::Template.register_tag('cache_bust', Jekyll::CacheBust)