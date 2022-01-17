=begin

If we have this class:

=end
class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
=begin

What would happen if we added a play method to the Bingo class, keeping in mind
that there is already a method of this name in the Game class that the Bingo
class inherits from.

=end

# The `play` method in the `Bingo` class would then override the `play` method in
# the `Game` class.
