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

class Hand
  attr_accessor :total, :cards

  def initialize
    @total = 0
    @cards = []
  end

  def reset
    self.cards = []
  end

  def busted?
    total > Game::WINNING_VALUE
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

  def total_score
    running_total = tally_hand_minus_aces
    num_aces = tally_num_aces

    num_aces.times do
      # Aces are only worth 1 point if adding 11 would case a bust
      running_total += ((running_total + 11) > Game::WINNING_VALUE ? 1 : 11)
    end
    self.total = running_total
  end
end

class Participant
  attr_accessor :game_score
  attr_reader :hand

  def initialize
    @game_score = 0
    @hand = Hand.new
  end

  def reset_game_score
    self.game_score = 0
  end
end

class Player < Participant
  include Displayable

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

class Dealer < Participant
  def can_stop?
    hand.total >= Game::DEALER_STAY_VALUE && !hand.busted?
  end
end

class Deck
  attr_accessor :cards
  attr_reader :player, :dealer

  def initialize(player, dealer)
    reset
    @player = player
    @dealer = dealer
  end

  def reset
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
  end

  def deal(participant)
    card = cards.sample
    participant.hand.cards << card
    cards.delete(card)
  end

  def deal_starting_hand
    [player, dealer].each do |participant|
      2.times { deal(participant) }
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

  attr_reader :deck, :player, :dealer

  NAME = '21'
  WINNING_VALUE = 21
  DEALER_STAY_VALUE = 17
  POINTS_TO_WIN = 5

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new(player, dealer)
  end

  def start
    display_welcome
    play_game
    display_goodbye_message
  end

  private

  def play_game
    loop do
      main_game
      display_grand_winner
      full_reset
      break unless player.play_again?
    end
  end

  def main_game
    loop do
      deck.deal_starting_hand
      player_turn
      display_game(hide_dealer_cards: false)
      dealer_turn unless player.hand.busted?
      display_outcome
      increment_game_score
      break if grand_winner?
      reset_hands
    end
  end

  def player_turn
    loop do
      update_score
      display_game(hide_dealer_cards: true)
      player_choice = ask_hit_or_stay

      if player_choice.start_with?('h')
        advance_player_turn
      end
      break if player_choice.start_with?('s') || player.hand.busted?
    end
    display_player_stay unless player.hand.busted?
  end

  def advance_player_turn
    deck.deal(player)
    update_score
    display_game
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

  def display_player_stay
    clear
    display_game(hide_dealer_cards: true)

    prompt "You chose to stay.\n\n"
    prompt_player_to_continue
  end

  def dealer_turn
    loop do
      break if dealer.can_stop? || dealer.hand.busted?
      deck.deal(dealer)
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

  def update_score
    player.hand.total_score
    dealer.hand.total_score
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

  # rubocop:disable Metrics/AbcSize
  def detect_outcome
    if player.hand.busted?
      :player_bust_dealer_win
    elsif dealer.hand.busted?
      :dealer_bust_player_win
    elsif player.hand.total == dealer.hand.total
      :tie
    elsif player.hand.total > dealer.hand.total
      :no_bust_player_win
    elsif dealer.hand.total > player.hand.total
      :no_bust_dealer_win
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def display_game(hide_dealer_cards: true)
    clear
    puts <<-GAME
                  -Grand Score-
                Player: #{player.game_score} Dealer: #{dealer.game_score}
           ============================

      Player hand: #{join_card_list(player)}

      Dealer hand: #{determine_dealer_hand_display(hide_dealer_cards)}

                       ----

                 Player Points: #{player.hand.total}
                 Dealer Points: #{determine_dealer_score_display(hide_dealer_cards)}

                    ==========

    GAME
  end

  def join_card_list(participant)
    card_list(participant).join(', ')
  end

  def card_list(participant)
    card_list = []
    participant.hand.cards.each do |card|
      card_list << "#{card.value} of #{card.suit}"
    end
    card_list
  end

  def determine_dealer_hand_display(hide_dealer_cards)
    !!hide_dealer_cards ? '??' : join_card_list(dealer)
  end

  def determine_dealer_score_display(hide_dealer_cards)
    !!hide_dealer_cards ? '??' : dealer.hand.total
  end

  def increment_game_score
    case detect_outcome
    when :player_bust_dealer_win then dealer.game_score += 1
    when :no_bust_dealer_win     then dealer.game_score += 1
    when :dealer_bust_player_win then player.game_score += 1
    when :no_bust_player_win     then player.game_score += 1
    end
  end

  def grand_winner?
    player.game_score == POINTS_TO_WIN || dealer.game_score == POINTS_TO_WIN
  end

  def display_grand_winner
    clear
    if player.game_score == POINTS_TO_WIN
      prompt "You are the grand winner!!!"
    elsif dealer.game_score == POINTS_TO_WIN
      prompt "Sorry, the dealer wins the game this time."
    end
    puts
  end

  def full_reset
    deck.reset
    reset_hands
    reset_game_score
  end

  def reset_game_score
    player.reset_game_score
    dealer.reset_game_score
  end

  def reset_hands
    player.hand.reset
    dealer.hand.reset
  end
end

Game.new.start
