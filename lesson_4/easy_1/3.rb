=begin

In the last question we had a module called Speed which contained a go_fast
method. We included this module in the Car class as shown below.

=end

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

=begin

When we called the go_fast method from an instance of the Car class (as shown
below) you might have noticed that the string printed when we go fast includes
the name of the type of vehicle we are using. How is this done?

=end

>> small_car = Car.new
>> small_car.go_fast
# => I am a Car and going super fast!

# In this case, the `self` referenced within the string interpolation is inside
# of an instance method, so it references the calling object, which in this case
# is the `Car` object referenced by variable `small_car`. When the `class`
# method is called upon variable `small_car`, this returns the class of the
# calling object, which in this case is class `Car`, as per the printed
# `string`. String interpolation automatically calls the `to_s` method for us.
