class Machine
  # attr_writer :switch

  def start
    self.flip_switch(:on)
  end

  def stop
    self.flip_switch(:off)
  end

  def show_switch_state
    p switch
  end
  
  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

# Modify this class so both flip_switch and the setter method switch= are private
# methods.

light = Machine.new
light.show_switch_state
light.start
light.show_switch_state
light.stop
light.show_switch_state
