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

module Wheelieable
  def do_wheely
    puts "We're doin a wheely!!"
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model

  @@num_cars = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@num_cars += 1
  end

  def self.num_cars
    @@num_cars
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

  def age
    "This vehicle is #{years_old} years old."
  end

  private

  def years_old
    time = Time.now
    time.year - year
  end
end

class MyCar < Vehicle
  DETAILS = 'This is my personal car.'
end

class MyTruck < Vehicle
  DETAILS = 'This is my personal truck.'
end

class MyScooter < Vehicle
  DETAILS = 'This is my scooter'

  include Wheelieable
end

class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(name)
    grade > name.grade
  end

  protected

  attr_reader :grade

end

joe = Student.new('joe', 90)
bob = Student.new('bob', 70)

puts "Well done!" if joe.better_grade_than?(bob)

# miata = MyCar.new(2007, 'black', 'mazda')
# p miata
# miata.speed_up(50)
# p miata
# miata.brake(25)
# p miata
# miata.shut_off
# p miata
# miata.change_color('blue')
# p miata
# puts miata.color
# MyCar.gas_milage(50, 300)
# p miata
# puts miata
# p MyCar::DETAILS
# p MyTruck::DETAILS

# p Vehicle::num_cars
# scoot = MyScooter.new(1995, 'white', 'honda')
# p scoot
# scoot.do_wheely
# p scoot
# puts MyCar.ancestors
# puts MyScooter.ancestors
# puts Vehicle.ancestors

# puts miata.age
