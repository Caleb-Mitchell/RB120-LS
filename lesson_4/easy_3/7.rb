=begin

What is used in this class but doesn't add any value?

=end
class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end
end

# The attr_accessors for both brightness and color, as they are both explicity 
# specified within the `information` class method.

# (The LS answer is the `return` keyword within the `information` method, as the
# line would be implicity returned anyway, techincally the attr_accessors do
# provide *potential* value).
