=begin

Alan created the following code to keep track of items for a shopping cart application he's writing:

=end
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end
=begin

Alyssa looked at the code and spotted a mistake. "This will fail when update_quantity is called", she says.

Can you spot the mistake and how to address it?

=end

# Currently, calling `update_quantity` initializes a local variable named
# `quantity`. In order to reassign the value of the instance variable `quantity`
# within the method, `quantity` needs to be prepended with `self`, to tell ruby
# that we mean to call a setter method on the calling object. This would also
# require changing from an attr_reader to an attr_accessor for the quality
# instance variable. We could also change the local variable for quantity in
# line 16 to an instance variable, and make the change directly.
