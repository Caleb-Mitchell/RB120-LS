=begin

What could you add to this class to simplify it and remove two methods from the
class definition while still maintaining the same functionality?

=end
class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end

# We could add attr_accessor :type, allowing us to remove both the `type` getter
# method, as well as the `type` setter method. We could then also change
# `@type` within the `describe_type` instance method to a getter method call,
# `type`.

