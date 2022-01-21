require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, player_marker)
    @squares[num].marker = player_marker
  end

  def [](num)
    @squares[num].marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def find_at_risk_square
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares)
        # binding.pry
        # need to select the int object from line which represents the index
        # of the marker of INITIAL_MARKER
        return line.select.with_index { |square, idx| squares[idx].marker == Square::INITIAL_MARKER }
      end
    end
    nil
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----    1 | 2 | 3"
    puts "     |     |        --- --- ---"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}      4 | 5 | 6"
    puts "     |     |        --- --- ---"
    puts "-----+-----+-----    7 | 8 | 9"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def two_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker, score = 0)
    @marker = marker
    @score = score
  end

  def add_point_to_score
    @score += 1
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER
  POINTS_TO_WIN = 2

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message
    loop do
      main_game
      display_grand_winner
      break unless play_again?
      full_reset
    end
    display_goodbye_message
  end

  private

  def main_game
    loop do
      display_board
      player_move
      display_result
      reset
      break if grand_winner?
    end
  end

  def player_move
    loop do
      current_player_moves
      update_score if board.someone_won?
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_grand_winner
    if human.score == POINTS_TO_WIN
      prompt "You are the grand winner!"
    elsif computer.score == POINTS_TO_WIN
      prompt "Sorry, the computer is the grand winner."
    end
    puts ""
  end

  def grand_winner?
    human.score == POINTS_TO_WIN || computer.score == POINTS_TO_WIN
  end

  def update_score
    if board.winning_marker == human.marker
      @human.add_point_to_score
    elsif board.winning_marker == computer.marker
      @computer.add_point_to_score
    end
  end

  def clear
    system 'clear'
  end

  def prompt(msg)
    puts "=> #{msg}"
  end

  def display_welcome_message
    puts <<-MSG

         ====== Welcome to TicTacToe ======         
                        --
     Try to get #{POINTS_TO_WIN} in a row, before the computer!
                        --
            Press Enter to continue...
    MSG
    gets
    clear
  end

  def display_goodbye_message
    clear
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts "--Current Score-- (First to #{POINTS_TO_WIN} wins!)"
    puts "Player: #{human.score}"
    puts "Computer: #{computer.score}"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def human_moves
    prompt "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      prompt "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  # TODO check if board has a line threat and that threat
  # is using the computer marker
  # def computer_threatens?

  # end

  # TODO check if board has a line threat and that threat
  # is using the player marker
  # def player_threatens?

  # end

  def computer_moves
    # board[board.unmarked_keys.sample] = computer.marker

    # Update this for defense and offense A.I.
    # Right now, the board object is a hash, and we use the
    # collection setter method to set the value of the computer marker
    # to the location key of the board hash when the computer moves
    #
    # I need to determine this location key, with logic,
    # instead of the current random choice, before setting the marker

    # square = nil

    # offense first
    # binding.pry
    # Board::WINNING_LINES.each do |line|

    binding.pry
    square = board.find_at_risk_square
    # break if square

    # # defense
    # WINNING_LINES.each do |line|
    #   square = board.find_at_risk_square
    #   break if square
    # end

    # pick the middle square if it's open
    if !square
      square = 5 if board[5] == Square::INITIAL_MARKER
    end
    binding.pry

    # pick a random square
    if !square
      square = board.unmarked_keys.sample
    end
    binding.pry

    board[square] = computer.marker
    binding.pry
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      prompt "You won!"
    when computer.marker
      prompt "Computer won!"
    else
      prompt "It's a tie!"
    end
    prompt "Hit any key to continue."
    gets
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def full_reset
    reset
    human.score = 0
    computer.score = 0
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end
end

game = TTTGame.new
game.play
