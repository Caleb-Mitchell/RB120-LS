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

  def >(other_move)
    win?(@value, other_move.value)
  end

  def to_s
    @value
  end

  protected

  attr_reader :value
end

class Player
  attr_accessor :move, :name, :score, :move_history

  WINNING_SCORE = 3

  def initialize
    @score = 0
    @move_history = []
  end

  def winner?
    score == WINNING_SCORE
  end

  def add_to_history!(move)
    move_history << move
  end

  def display_move_history
    "\nMove history for #{name}: \n=> #{move_history.join(', ')}."
  end
end

class Human < Player
  def initialize
    super()
    set_name
  end

  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty? || n.chars.all? { |ele| ele == ' ' }
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "\n=> Please choose (r)ock, (p)aper, (sc)issors, " \
           "(l)izard, or (sp)pock:"

      choice = check_choice_size(gets.chomp.downcase)

      break if Move::VALID_CHOICES.include? choice
      puts "Sorry, invalid choice."
    end

    self.move = Move.new(choice)
    add_to_history!(choice)
  end

  def check_choice_size(choice)
    return interpret_abbrev(choice) if choice.size() == 1 || choice.size() == 2
    choice
  end

  def interpret_abbrev(choice)
    case choice
    when 'r' then 'rock'
    when 'p' then 'paper'
    when 'l' then 'lizard'
    when 'sc' then 'scissors'
    when 'sp' then 'spock'
    when 's' then spock_or_scissors()
    end
  end

  def spock_or_scissors
    loop do
      puts '=> Please input "sc" for scissors, or "sp" for spock'
      new_abbr = gets.chomp.downcase

      return "scissors" if new_abbr == "sc"
      return "spock" if new_abbr == "sp"
    end
  end
end

class Computer < Player
  def choose
    choice = apply_personality

    self.move = Move.new(choice)
    add_to_history!(choice)
  end

  private

  attr_reader :apply_personality
end

class R2D2Bot < Computer
  def initialize
    super()
    @name = 'R2D2'
  end

  def apply_personality
    'rock'
  end
end

class HalBot < Computer
  def initialize
    super()
    @name = 'Hal'
  end

  def apply_personality
    ((['scissors'] * 3) + ['rock']).sample
  end
end

class ChappieBot < Computer
  def initialize
    super()
    @name = 'Chappie'
  end

  def apply_personality
    'paper'
  end
end

class SonnyBot < Computer
  def initialize
    super()
    @name = 'Sonny'
  end

  def apply_personality
    ((['spock'] * 3) + ['lizard']).sample
  end
end

class Number5Bot < Computer
  def initialize
    super()
    @name = 'Number 5'
  end

  def apply_personality
    Move::VALID_CHOICES.sample
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  BOT_NAMES = [R2D2Bot, HalBot, ChappieBot, SonnyBot, Number5Bot]

  def initialize
    @human = Human.new
    @computer = BOT_NAMES.sample.new
  end

  private

  def clear_screen
    puts "\e[H\e[2J"
  end

  def prompt(message)
    puts "=> #{message}"
  end

  # rubocop:disable Metrics/MethodLength
  def display_welcome_message
    welcome_message = <<~MSG
  Welcome to Rock-Paper-Scissors-Lizard-Spock #{human.name}!
     ---------------------
     The rules are simple...
     Choose your "hand signal", and see if you beat the computer's choice!
     ---------------------
     Scissors cuts Paper covers Rock crushes
     Lizard poisons Spock smashes Scissors
     decapitates Lizard eats Paper disproves
     Spock vaporizes Rock crushes Scissors.
     ---------------------
    MSG

    prompt welcome_message
  end
  # rubocop:enable Metrics/MethodLength

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
    elsif computer.move > human.move
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
    elsif computer.move > human.move
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

  # Set padding to accomodate either the computer name
  # or human name, whichever is longer.
  def find_score_padding(name)
    all_names = [Computer.name, human.name]
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
    self.computer = BOT_NAMES.sample.new
  end

  def reset_game
    reset_score
    reset_move_records
    set_new_computer
  end

  def display_results
    display_grand_winner
    display_move_records
  end

  public

  def play
    loop do
      start_game

      until grand_winner?
        play_round
      end
      display_results
      reset_game

      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
