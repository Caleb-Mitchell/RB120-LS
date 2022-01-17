=begin

How do you find where Ruby will look for a method when that method is called?
How can you find an object's ancestors?

=end

module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

=begin

What is the lookup chain for Orange and HotSauce?

=end

# The method lookup chain for Orange is:
# - Orange, Taste, Object, Kernel, BasicObject
#
# The method lookup chain for HotSauce is:
# - Hotsauce, Taste, Object, Kernel, BasicObject
#
# You can find an object's ancestors by calling the `ancestors` method on the
# class itself.

p Orange.ancestors

p HotSauce.ancestors
