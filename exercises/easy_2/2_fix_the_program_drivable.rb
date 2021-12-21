module Drivable
  # def self.drive
  def drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive
