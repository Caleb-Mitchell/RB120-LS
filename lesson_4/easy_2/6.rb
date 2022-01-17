=begin

If I have the following class:

=end
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end
=begin

Which one of these is a class method (if any) and how do you know? How would you
call a class method?

=end

# `self.manufacturer` is a class method, as the method name is prepended with
# `self`.
#
# You would call it directly on the class, like `Television.manufacturer`.
