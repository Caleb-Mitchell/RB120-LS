=begin

If we have the class below, what would you need to call to create a new instance
of this class.

=end

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

# To instantiate an object of class `Bag`, we could need to call the `new`
# method on `Bag`, with you two arguments, one for each of the two arguments in
# the `initialize` method within the class.
#
# Bag.new(:blue, :velvet)
