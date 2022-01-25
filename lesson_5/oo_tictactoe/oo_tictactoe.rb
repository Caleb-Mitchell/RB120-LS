require 'pry'

class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
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

  def find_line_threats
    line_threats = WINNING_LINES.select do |line|
      squares = @squares.values_at(*line)
      two_identical_markers?(squares)
    end
    line_threats
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
  attr_accessor :marker
  attr_accessor :score

  def initialize(score = 0)
    @score = score
  end

  def add_point_to_score
    @score += 1
  end
end

class TTTGame
  POINTS_TO_WIN = 2

  attr_reader :board
  attr_accessor :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
  end

  def play
    clear
    display_welcome_message
    loop do
      setup_players
      main_game
      display_grand_winner
      break unless play_again?
      full_reset
    end
    display_goodbye_message
  end

  private

  def setup_players
    determine_markers
    determine_first_player
  end

  def determine_markers
    human.marker = obtain_user_choice_marker
    computer.marker = if human.marker == "X"
                        "O"
                      elsif human.marker == "O"
                        "X"
                      end
  end

  def obtain_user_choice_marker
    puts "Which marker would you like? X or O?"
    puts ""
    print "=> Please enter X or O: "
    gets.chomp.upcase
  end

  def determine_first_player
    turn_chooser = ask_player_who_should_choose
    @first_to_move = determine_first_turn(turn_chooser)
    set_current_marker
    clear
  end

  def set_current_marker
    @current_marker = @first_to_move
  end

  def alternate_first_turn
    @first_to_move = if @first_to_move == human.marker
                       computer.marker
                     else
                       human.marker
                     end
    set_current_marker
  end

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
            Press Enter to continue.
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
      display_square_num_error
    end

    board[square] = human.marker
  end

  def player_threatens?(line_threats, player_marker)
    line_threats.any? do |line|
      squares = board.squares.values_at(*line)
      squares.any? { |square| square.marker == player_marker }
    end
  end

  def find_winning_square(line_threats, winning_marker)
    line_threats.each do |line|
      squares = board.squares.values_at(*line)
      if squares.count { |square| square.marker == winning_marker } == 2
        return line.select.with_index { |_, idx| squares[idx].unmarked? }.first
      end
    end
    nil
  end

  def address_threat(line_threats)
    # offense first, then defense
    [computer, human].each do |player|
      if player_threatens?(line_threats, player.marker)
        square = find_winning_square(line_threats, player.marker)
      end
      return square if square
    end
    nil
  end

  def computer_moves
    line_threats = board.find_line_threats
    square = address_threat(line_threats)

    # pick the middle square if it's open
    square = 5 if !square && board[5] == Square::INITIAL_MARKER
    # pick a random square
    square = board.unmarked_keys.sample if !square

    board[square] = computer.marker
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
    enter_to_continue
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if valid_yes_or_no? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def enter_to_continue
    prompt "Hit Enter to continue."
    gets
  end

  def reset
    board.reset
    alternate_first_turn
    clear
  end

  def full_reset
    reset
    human.score = 0
    computer.score = 0
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def valid_first_turn_choice?(first_turn_choice)
    ['p', 'player', 'c', 'computer'].include?(first_turn_choice)
  end

  def valid_yes_or_no?(user_input)
    ['y', 'yes', 'n', 'no'].include?(user_input)
  end

  def display_square_num_error
    clear
    display_board
    prompt "Invalid input, please enter a valid square number."
    puts ""
    prompt "Choose a square (#{board.unmarked_keys}): "
  end

  def player_first_turn_choice
    clear
    first_turn_choice = ''
    loop do
      first_turn_choice = obtain_user_choice_first_turn
      break if valid_first_turn_choice?(first_turn_choice)
      clear
      prompt "Sorry, please enter either (p)layer, or (c)omputer. Try again."
      puts ""
    end
    current_player(first_turn_choice)
  end

  def obtain_user_choice_first_turn
    puts "Who should go first? (p)layer or (c)omputer?"
    print "(Starting player will alternate each round)\n\n"
    print "=> Please enter (p)layer, or (c)omputer: "
    gets.chomp.downcase
  end

  def current_player(first_turn_choice)
    if first_turn_choice.start_with?('p')
      human.marker
    elsif first_turn_choice.start_with?('c')
      computer.marker
    end
  end

  def ask_player_who_should_choose
    player_choice = ''
    loop do
      player_choice = obtain_user_choice_to_choose
      break if valid_yes_or_no?(player_choice)
      system 'clear'
      puts "Sorry, please enter (y)es or (n)o. Try again."
      puts ""
    end
    player_choice
  end

  def obtain_user_choice_to_choose
    clear
    puts "Would you like to choose who goes first?\n" \
           "(If no, the computer will choose randomly)\n\n"
    print "=> Please enter (y)es or (n)o: "
    gets.chomp.downcase
  end

  def determine_first_turn(turn_chooser)
    current_player = if turn_chooser.start_with?('y')
                       player_first_turn_choice
                     else
                       [human.marker, computer.marker].sample
                     end
    current_player
  end
end

game = TTTGame.new
game.play
