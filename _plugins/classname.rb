module Classname
  def classname(input)
    "<span class='inlineCode'>#{input}</span>"
  end
end

Liquid::Template.register_filter(Classname)