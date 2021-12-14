class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  # def name
  #   @name
  # end

  # def name=(value)
  #   @name = value
  # end
end

bob = Person.new('bob')
puts bob.name
bob.name = 'Robert'
puts bob.name
