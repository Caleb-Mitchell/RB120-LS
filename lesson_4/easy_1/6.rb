=begin

What could we add to the class below to access the instance variable @volume?

=end

class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end

  # def get_volume
  #   @volume
  # end
end

# We can technically access instance variables without a getter method at all,
# by calling the `instance_variable_get` method on an object of class `Cube`,
# with the instance variable `@volume` passed to the method as an argument.
# Although, this is generally not a good idea.
#
# We could also either add a getter method for volume, or add an attr_reader for
# it.
