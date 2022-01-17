=begin

In the last question we had the following classes:

=end
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
=begin

If we call Hello.hi we get an error message. How would you fix this?

=end

# We could do one of two things:
# 1. define a `Hi` class method in the `Hello` class that accomplishes our
# desired functionality.
# 2. instead call the `hi` method on an object of class `Hello`, instead of the
# class itself.
