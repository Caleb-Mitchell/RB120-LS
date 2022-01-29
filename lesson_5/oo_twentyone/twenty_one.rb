module Displayable
  def clear
    system 'clear'
  end

  def prompt(message)
    puts "=> #{message}"
  end

  def prompt_player_to_continue
    prompt "Press Enter to continue."
    gets
  end

  def display_goodbye_message
    clear
    prompt "Thanks for playing #{self.class::NAME}!"
  end
end

module Hand
  def hit
    deck.deal(self)
  end

  def busted?
    score > Game::WINNING_VALUE
  end

  def tally_num_aces
    num_aces = 0
    cards.each do |card|
      num_aces += 1 if card.value == 'Ace'
    end
    num_aces
  end

  def tally_hand_minus_aces
    hand_minus_aces = 0
    cards.each do |card|
      if ('2'..'10').to_a.include?(card.value)
        hand_minus_aces += card.value.to_i
      elsif %w(Jack Queen King).include?(card.value)
        hand_minus_aces += 10
      end
    end
    hand_minus_aces
  end

  def hand_total_score
    running_total = tally_hand_minus_aces
    num_aces = tally_num_aces

    num_aces.times do
      # Aces are only worth 1 point if adding 11 would case a bust
      running_total += ((running_total + 11) > Game::WINNING_VALUE ? 1 : 11)
    end
    running_total
  end
end

class Participant
  include Hand

  attr_accessor :cards, :score, :grand_score
  attr_reader :deck

  def initialize(deck)
    @cards = []
    @score = 0
    @grand_score = 0
    @deck = deck
  end

  def reset_score
    @score = 0
  end

  def reset_grand_score
    @grand_score = 0
  end

  def reset_hand
    @cards = []
  end
end

class Deck
  attr_reader :cards

  def initialize
    reset
  end

  def deal(participant)
    card = cards.sample
    participant.cards << card
    cards.delete(card)
  end

  def reset
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
  end
end

class Card
  attr_reader :suit, :value

  SUITS = %w(Hearts Diamonds Clubs Spades)
  VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end

class Game
  include Displayable

  NAME = '21'

  attr_reader :deck, :player, :dealer

  WINNING_VALUE = 21
  DEALER_STAY_VALUE = 17
  POINTS_TO_WIN = 5

  def initialize
    @deck = Deck.new
    @player = Participant.new(deck)
    @dealer = Participant.new(deck)
  end

  def start
    display_welcome
    loop do
      main_game
      display_grand_winner
      full_reset
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def main_game
    loop do
      deal_starting_hand
      player_turn
      display_game(hide_dealer_cards: false)
      dealer_turn unless player.busted?
      display_outcome
      increment_grand_score
      break if grand_winner?
      reset_hands
    end
  end

  def deal_starting_hand
    [player, dealer].each do |participant|
      2.times do
        deck.deal(participant)
      end
    end
  end

  def reset_hands
    player.reset_hand
    dealer.reset_hand
  end

  def reset_grand_score
    player.reset_grand_score
    dealer.reset_grand_score
  end

  def full_reset
    deck.reset
    reset_hands
    reset_grand_score
  end

  def display_grand_winner
    clear
    if player.grand_score == POINTS_TO_WIN
      prompt "You are the grand winner!!!"
    elsif dealer.grand_score == POINTS_TO_WIN
      prompt "Sorry, the dealer wins the game this time."
    end
    puts
  end

  def increment_grand_score
    case detect_outcome
    when :player_bust_dealer_win then dealer.grand_score += 1
    when :no_bust_dealer_win     then dealer.grand_score += 1
    when :dealer_bust_player_win then player.grand_score += 1
    when :no_bust_player_win     then player.grand_score += 1
    end
  end

  def grand_winner?
    player.grand_score == POINTS_TO_WIN || dealer.grand_score == POINTS_TO_WIN
  end

  def dealer_turn
    loop do
      break if dealer_can_stop? || dealer.busted?
      dealer.hit
      update_score
      display_game(hide_dealer_cards: false)
      display_dealer_hits
    end
  end

  def display_dealer_hits
    display_game(hide_dealer_cards: false)

    prompt "Dealer hits!\n\n"
    prompt_player_to_continue
  end

  def ask_hit_or_stay
    player_choice = ''
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_choice = gets.chomp.downcase
      break if ['h', 'hit', 's', 'stay'].include?(player_choice)
      clear
      display_game(hide_dealer_cards: true)
      prompt "Sorry, not a valid choice, please enter (h)it or (s)tay.\n\n"
    end
    player_choice
  end

  def dealer_can_stop?
    dealer.score >= DEALER_STAY_VALUE && !dealer.busted?
  end

  def player_turn
    loop do
      update_score
      display_game(hide_dealer_cards: true)
      player_choice = ask_hit_or_stay

      if player_choice.start_with?('h')
        advance_player_turn
      end
      break if player_choice.start_with?('s') || player.busted?
    end
    display_player_stay unless player.busted?
  end

  def advance_player_turn
    player.hit
    update_score
    display_game
  end

  def display_player_stay
    clear
    display_game(hide_dealer_cards: true)

    prompt "You chose to stay.\n\n"
    prompt_player_to_continue
  end

  def update_score
    player.score = player.hand_total_score
    dealer.score = dealer.hand_total_score
  end

  # rubocop:disable Metrics/MethodLength
  def display_welcome
    clear
    puts <<-MSG

           ====== Welcome to 21! ======         

                    - Rules -

     - The player and dealer are both dealt 2 random cards.
    
     - Your goal is to get as close as you can to 21 points,
       without going over but higher than the dealer's total.

                    - Points -

                Cards 2-10 = equal to face value
         jack, queen, king = 10
                       ace = 1 or 11

                        --

             - Playing to best of #{POINTS_TO_WIN}! - 

                    ==========

    MSG
    prompt_player_to_continue
  end

  def detect_outcome
    if player.busted?
      :player_bust_dealer_win
    elsif dealer.busted?
      :dealer_bust_player_win
    elsif player.score == dealer.score
      :tie
    elsif player.score > dealer.score
      :no_bust_player_win
    elsif dealer.score > player.score
      :no_bust_dealer_win
    end
  end

  def display_outcome
    clear
    display_game(hide_dealer_cards: false)

    case detect_outcome
    when :player_bust_dealer_win
      prompt "You busted, dealer wins this round.\n\n"
    when :dealer_bust_player_win
      prompt "Dealer busted, you win this round!\n\n"
    when :tie
      prompt "It's a tie!\n\n"
    when :no_bust_player_win
      prompt "You win this round!\n\n"
    when :no_bust_dealer_win
      prompt "Sorry, dealer wins this round.\n\n"
    end
    prompt_player_to_continue
  end
  # rubocop:enable Metrics/MethodLength

  def display_game(hide_dealer_cards: true)
    clear
    puts <<-GAME
                  -Grand Score-
                Player: #{player.grand_score} Dealer: #{dealer.grand_score}
           ============================

      Player hand: #{join_card_list(player)}

      Dealer hand: #{determine_dealer_hand_display(hide_dealer_cards)}

                       ----

                 Player Points: #{player.score}
                 Dealer Points: #{determine_dealer_score_display(hide_dealer_cards)}

                    ==========

    GAME
  end

  def join_card_list(participant)
    card_list(participant).join(', ')
  end

  def determine_dealer_hand_display(hide_dealer_cards)
    !!hide_dealer_cards ? '??' : join_card_list(dealer)
  end

  def determine_dealer_score_display(hide_dealer_cards)
    !!hide_dealer_cards ? '??' : dealer.score
  end

  def card_list(participant)
    card_list = []
    participant.cards.each do |card|
      card_list << "#{card.value} of #{card.suit}"
    end
    card_list
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if valid_yes_or_no? answer
      display_play_again_error
    end

    answer == 'y'
  end

  def display_play_again_error
    clear
    prompt "Sorry, not a valid choice, please enter (y)es or (n)o."
    puts
  end

  def valid_yes_or_no?(user_input)
    ['y', 'yes', 'n', 'no'].include?(user_input)
  end
end

Game.new.start
