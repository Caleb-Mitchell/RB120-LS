=begin

If we have this class:

=end
class Game
  def play
    "Start the game!"
  end
end
=begin

And another class:

=end
class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
=begin

What can we add to the Bingo class to allow it to inherit the play method from
the Game class?

=end

# < Game

game = Bingo.new

p game.play
