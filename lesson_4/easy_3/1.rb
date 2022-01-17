=begin

If we have this code:

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

What happens in each of the following cases:

=end
hello = Hello.new
hello.hi

# prints "Hello"

hello = Hello.new
hello.bye

# return error, undefined method `bye`

hello = Hello.new
hello.greet

# return error, wrong number of arguments

hello = Hello.new
hello.greet("Goodbye")

# prints "Goodbye"

Hello.hi

# return error, undefined class method `hi`
