=begin

What is the default return value of to_s when invoked on an object? Where could
you go to find out if you want to be sure?

=end

# The default return value of `to_s` is the name of the object's class, followed
# by an encoding of the object id, a numeric value uniquely identifying the object in memory.
#
# The documentation :)
