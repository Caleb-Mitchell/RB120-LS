=begin
module Rentable
  def rent(book)
    puts "#{book}"
  end
end

class Books
  include Rentable
end

fiction = Books.new
# fiction.rent("I rented this")
=end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def self.gas_milage(gallons, miles)
    puts "This vehicle is getting #{miles / gallons} miles to the gallon."
  end

  def change_color(new_color)
    self.color = new_color
  end

  def to_s
    "A #{year} #{color} #{model}."
  end

  def speed_up(speed)
    @speed += speed
    puts "Speed increased by #{@speed}."
  end

  def brake(speed)
    @speed -= speed
    puts "Speed decreased by #{@speed}."
  end

  def shut_off
    @speed = 0
    puts 'Car shut off.'
  end
end

class MyCar < Vehicle
  DETAILS = 'This is my personal car.'
end

class MyTruck < Vehicle
  DETAILS = 'This is my personal truck.'
end

miata = MyCar.new(2007, 'black', 'mazda')
p miata
miata.speed_up(50)
p miata
miata.brake(25)
p miata
miata.shut_off
p miata
miata.change_color('blue')
p miata
puts miata.color
MyCar.gas_milage(50, 300)
p miata
puts miata
p MyCar::DETAILS
p MyTruck::DETAILS
