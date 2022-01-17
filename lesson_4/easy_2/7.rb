=begin

If we have a class such as the one below:

=end
class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end
=begin

Explain what the @@cats_count variable does and how it works. What code would
you need to write to test your theory?

=end

# `@@cats_count` is a class variable, as the variable name is prefaced with two
# @ symbols, and it is initialized at the class level. 
#
# Each time a Cat object is created, the `Cat` class `initialize` method is
# run, and because class variables are scoped at the class level and one copy
# of class variables are shared amongst all objects of a class, each time the
# `initialize` method is run `@@cats_count` will be incremented by 1.
#
# We could test this by instantiating a certain number of `Cat` objects with the `new` method,
# and then calling the class method `self.cats_count` to see if the number
# returned matches however many `Cat` objects we created.

steve = Cat.new('calico')
bob = Cat.new('tuxedo')
joey = Cat.new('tabby')

p Cat.cats_count
