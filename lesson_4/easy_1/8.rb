=begin

If we have a class such as the one below:

=end

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

=begin

You can see in the make_one_year_older method we have used self. What does self
refer to here?

=end

# self here refers to the calling object, an object of class `Cat`,
# as it is used within an instance method.
