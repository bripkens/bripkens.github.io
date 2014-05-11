module IsoDate
  def isodate(input)
    input.iso8601
  end
end

Liquid::Template.register_filter(IsoDate)