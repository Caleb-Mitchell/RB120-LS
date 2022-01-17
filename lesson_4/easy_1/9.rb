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

In the name of the cats_count method we have used self. What does self refer to in this context?

=end

# In this context, self refers to the class itself, class `Cat`, as it is not
# being used within an instance method.
