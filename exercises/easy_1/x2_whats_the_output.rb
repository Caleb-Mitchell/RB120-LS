class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    # @name.upcase!
    # "My name is #{@name}."
    "My name is #{@name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)

puts fluffy.name # Fluffy
puts fluffy      # 'My name is FLUFFY.'
puts fluffy.name # FLUFFY - FIXED to Fluffy
puts name        # Fluffy

puts "\n--Further Exploration--"
name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

