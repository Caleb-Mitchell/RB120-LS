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

What would happen if I called the methods like shown below?

=end
tv = Television.new # This instantiates a `Television` object to variable `tv`.
tv.manufacturer # This will return error unknown method, as we are trying to
# call a class method on an instance of class `Television`.
tv.model # This will execute the method logic of the `model` instance method.

Television.manufacturer # This will execute the logic of class method `manufacturer`.
Television.model # This will return error unknown method, as we are trying to
# call an instance method on the class itself.
