=begin

We have an Oracle class and a RoadTrip class that inherits from the Oracle
class.

=end

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

=begin

What is the result of the following:

=end

trip = RoadTrip.new
trip.predict_the_future

# Because the instance method `choices` in class `RoadTrip` overrides the
# instance method higher up in the inheritence hierarchy in class `Oracle`, in
# this case the `predict_the_future` method call will function the same, but
# will instead use the array of strings within class `RoadTrip` instead of the
# array in parent class `Oracle`.
