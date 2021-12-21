class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end

  def wheels
    self.class::WHEEL_NUM
  end
end

class Car < Vehicle
  WHEEL_NUM = 4
end

class Motorcycle < Vehicle
  WHEEL_NUM = 2
end

class Truck < Vehicle
  WHEEL_NUM = 6

  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end
end

miata = Car.new('mazda', 'miata')
p miata.wheels #=> 4
