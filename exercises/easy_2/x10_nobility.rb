class Noble
  attr_reader :name, :title

  def initialize(name, title)
    @name = name
    @title = title
  end

  def combine_name_and_title
    "#{title} #{name}"
  end

  def walk
    "#{combine_name_and_title} struts forward"
  end
end

byron = Noble.new("Byron", "Lord")
p byron.walk
# => "Lord Byron struts forward"
