=begin

You are given the following code:

=end

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

=begin

What is the result of executing the following code:

=end

oracle = Oracle.new
oracle.predict_the_future

# The first line will create an object of class `Oracle`.
# The second calls the instance method `predict_the_future`, which will return a
# string object that begins "You will " and follows with a random selection from
# the array of strings within instance method `choices`.
