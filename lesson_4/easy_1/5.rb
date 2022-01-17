=begin

Which of these two classes has an instance variable and how do you know?

=end

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Class `Pizza` has an instance variable, as instances variables are defined using
# the `@` symbol. Class `Fruit` as it appears here has a local variable
# definited within its initialize method.
