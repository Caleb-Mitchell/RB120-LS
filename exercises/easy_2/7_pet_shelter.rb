class Pet
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @number_of_pets = 0
    @pets = []
  end

  def number_of_pets
    @number_of_pets
  end

  def add_pet(pet)
    @number_of_pets += 1
    @pets << "a #{pet.type} named #{pet.name}"
  end
end

class Shelter
  def initialize
    @owners = []
  end

  def adopt(owner, pet)
    @owners << owner unless @owners.include?(owner)
    owner.add_pet(pet)
  end

  def print_adoptions
    @owners.each do |owner|
      if owner.name == "The Animal Shelter"
        puts "#{owner.name} has the following unadopted pets:"
      else
        puts "#{owner.name} has adopted the following pets:"
      end

      owner.pets.each do |pet|
        puts pet.to_s
      end
      puts "\n"
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
peter        = Pet.new('dog', 'Peter')

asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')
cmitchell = Owner.new('C Mitchell')
animal_shelter = Owner.new('The Animal Shelter')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.adopt(cmitchell, peter)

shelter.adopt(animal_shelter, asta)
shelter.adopt(animal_shelter, laddie)
shelter.adopt(animal_shelter, fluffy)
shelter.adopt(animal_shelter, kat)
shelter.adopt(animal_shelter, ben)
shelter.adopt(animal_shelter, chatterbox)
shelter.adopt(animal_shelter, bluebell)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{cmitchell.name} has #{cmitchell.number_of_pets} adopted pets."
puts "#{animal_shelter.name} has #{animal_shelter.number_of_pets} unadopted pets."
