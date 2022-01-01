# TODO: add text "spock vaporizes rock" when spock wins, etc.

class Move
  WINNING_MOVES = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['rock', 'scissors']
  }
  VALID_CHOICES = WINNING_MOVES.keys()

  def initialize(value)
    @value = value
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
  attr_accessor :move_history

  WINNING_SCORE = 3

  def initialize
    set_name
    @score = 0
    @move_history = []
  end

  def winner?
    score == WINNING_SCORE
  end

  def move_history
    @move_history
  end

  def add_to_history!(move)
    self.move_history << move
  end

  def display_move_history
    "\nMove history for #{name}: \n=> #{move_history.join(", ")}."
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
      puts "\n=> Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if Move::VALID_CHOICES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)

    add_to_history!(choice)
  end
end

class Computer < Player
  COMP_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def initialize
    super()
    set_personality
  end

  def set_name
    self.name = COMP_NAMES.sample
  end

  def set_personality
    case name
    when 'R2D2'    then self.personality = :always_rock
    when 'Hal'     then self.personality = :often_scissors_no_paper
    when 'Chappie' then self.personality = :always_paper
    else                self.personality = :neutral
    end
  end

  def apply_personality
    case personality
    when :always_rock             then 'rock'
    when :often_scissors_no_paper then ['scissors', 'scissors', 'scissors', 'rock'].sample
    when :always_paper            then 'paper'
    when :neutral                 then Move::VALID_CHOICES.sample
    end
  end

  def choose
    personality_choice = apply_personality
    self.move = Move.new(personality_choice)

    add_to_history!(personality_choice)
  end

  private

  attr_accessor :personality
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

  def prompt(message)
    puts "=> #{message}"
  end

  def display_welcome_message
  welcome_message = <<-MSG
Welcome to Rock-Paper-Scissors-Lizard-Spock #{human.name}!"
   ---------------------
   The rules are simple...
   Choose your "hand signal", and see if you beat the computer's choice!
   ---------------------
   Scissors cuts Paper covers Rock crushes
   Lizard poisons Spock smashes Scissors
   decapitates Lizard eats Paper disproves
   Spock vaporizes Rock crushes Scissors
   ---------------------
  MSG

    prompt welcome_message
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
    puts "\n\n"
  end

  def display_grand_winner
    if human.winner?
      puts "\n#{human.name} is the grand winner!"
    elsif computer.winner?
      puts "\nSorry, #{computer.name} is the grand winner!"
    end
  end

  def display_move_records
    puts human.display_move_history
    puts computer.display_move_history
    puts
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

  def reset_move_records
    human.move_history = []
    computer.move_history = []
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

  def set_new_computer
    self.computer = Computer.new
  end

  def reset_game
    reset_score
    reset_move_records
    set_new_computer
  end

  def play
    loop do
      start_game

      until grand_winner?
        play_round
      end

      display_grand_winner
      display_move_records
      reset_game

      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
