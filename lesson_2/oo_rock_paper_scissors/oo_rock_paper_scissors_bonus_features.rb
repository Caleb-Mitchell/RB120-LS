require 'pry'
# TODO: add text "spock vaporizes rock" when spock wins, etc.
# TODO: make it look better like original implementation

class Move
  WINNING_MOVES = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'spock' => ['rock', 'scissors'],
    'lizard' => ['paper', 'spock']
  }
  VALID_CHOICES = WINNING_MOVES.keys()

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value = 'lizard'
  end

  def spock?
    @value = 'spock'
  end

  def win?(first, second)
    WINNING_MOVES[first].include?(second)
  end

  def lose?(first, second)
    WINNING_MOVES[second].include?(first)
  end

  def >(other_move)
    win?(@value, other_move.value)
  end

  def <(other_move)
    lose?(@value, other_move.value)
  end

  def to_s
    @value
  end

  protected

  attr_reader :value
end

class Player
  attr_accessor :move, :name, :score

  WINNING_SCORE = 3

  def initialize
    set_name
    @score = 0
  end

  def winner?
    score == WINNING_SCORE
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "\nPlease choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if Move::VALID_CHOICES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  COMP_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    self.name = COMP_NAMES.sample
  end

  def choose
    self.move = Move.new(Move::VALID_CHOICES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors #{human.name}!"
  end

  def display_goodbye_message
    puts "\nThanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "\n#{human.name} won!"
    elsif human.move < computer.move
      puts "\n#{computer.name} won!"
    else
      puts "\nIt's a tie!"
    end
  end

  def display_grand_winner
    if human.winner?
      puts "\n#{human.name} is the grand winner!"
    elsif computer.winner?
      puts "\nSorry, #{computer.name} is the grand winner!"
    end
  end

  def increment_score!
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def grand_winner?
    human.winner? || computer.winner?
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "\nSorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  # Set padding to either the longest possible computer name in random pool of
  # computer names, or human name, whichever is longer.
  def find_score_padding(name)
    all_names = Computer::COMP_NAMES.dup << human.name
    longest_name = all_names.max_by(&:length)
    1 + (longest_name.length - name.length)
  end

  def add_score_padding(score, name)
    score.to_s.rjust(find_score_padding(name))
  end

  def display_score
    puts "\nCurrent Score:"
    puts "#{human.name}: \
      #{add_score_padding(human.score, human.name)}"
    puts "#{computer.name}: \
      #{add_score_padding(computer.score, computer.name)}"
  end

  def start_game
    clear_screen
    display_welcome_message
  end

  def display_round_info
    display_moves
    display_score
    display_winner
  end

  def play_round
    human.choose
    computer.choose

    increment_score!

    clear_screen
    display_round_info
  end

  def play
    loop do
      start_game

      until grand_winner?
        play_round
      end
      display_grand_winner

      reset_score
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
