=begin

If we have these two methods in the Computer class:

=end
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# and

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

=begin

What is the difference in the way the code works?

=end

# The first option is using the `create_template` method to set the string value
# to the instance variable `@template` directly, while the second option uses
# the `create_template` method to call the setter method, defined by the
# attr_accessor for template, to set the string value to the same instance
# variable.
#
# The first option uses the `show_template` method to then call the `template`
# getter method created by the attr_accessor for template, to return the value
# referenced by instance variable `@template`, which references the value set by
# method `create_template`. The second option does the exact same thing, just
# prepending the `template` getter method with an unnecessary `self`. In either
# case they the receiver of the method is the calling object.
