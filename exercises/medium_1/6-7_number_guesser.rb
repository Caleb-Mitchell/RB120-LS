class GuessingGame

  attr_accessor :guesses_left

  def initialize(min_num, max_num)
    @min_num = min_num
    @max_num = max_num
  end

  def play
    reset
    play_game
    display_final_verdict
  end

  private

  def reset
    @secret_num = rand(@min_num..@max_num)
    @guesses_left = Math.log2(@max_num - @min_num).to_i + 1
  end

  def play_game
    loop do
      display_guesses_remaining
      decrement_guesses
      request_number
      detect_result
      display_result
      break if correct_guess? || out_of_guesses?
    end
  end

  def display_guesses_remaining
    if guesses_left == 1
      puts "You have #{guesses_left} guess remaining."
    else
      puts "You have #{guesses_left} guesses remaining."
    end
  end

  def decrement_guesses
    self.guesses_left -= 1
  end

  def request_number
    @user_num = nil
    loop do
      print "Enter a number between #{@min_num} and #{@max_num}: "
      @user_num = gets.chomp.to_i
      break if (@min_num..@max_num).cover?(@user_num)
      print "Invalid guess. "
    end
  end

  def detect_result
    if @user_num == @secret_num
      :correct
    elsif @user_num < @secret_num
      :too_low
    elsif @user_num > @secret_num
      :too_high
    end
  end

  def correct_guess?
    detect_result == :correct
  end

  def out_of_guesses?
    @guesses_left == 0
  end
  
  def display_result
    case detect_result
    when :correct then puts "That's the number!"
    when :too_low then puts "Your guess is too low."
    when :too_high then puts "Your guess is too high."
    end
    puts
  end

  def display_final_verdict
    if correct_guess?
      puts "You won!"
    else
      puts "You have no more guesses. You lost!"
    end
    puts
  end
end

game = GuessingGame.new(501, 1500)
game.play
