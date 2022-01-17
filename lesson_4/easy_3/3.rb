=begin

When objects are created they are a separate realization of a particular class.

Given the class below, how do we create two different instances of this class
with separate names and ages?

=end

class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

# By passing the `new` method different arguments representing their different
# names and ages.

steve = AngryCat.new(14, 'steve')
joey = AngryCat.new(17, 'joey')
