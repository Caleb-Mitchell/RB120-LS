=begin

How could you change the method name below so that the method name is more clear
and less repetitive?

=end

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def light_status
    "I have a brightness level of #{brightness} and a color of #{color}"
  end

end

# We could change the method name `light_status` to `display_status` or just
# `status`. As the
# method is within class `Light`, the fact that the status pertains to the Light
# class is implied.
