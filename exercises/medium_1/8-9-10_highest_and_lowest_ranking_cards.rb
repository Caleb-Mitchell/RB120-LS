require 'pry'

class Card
  include Comparable
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s 
    "#{rank} of #{suit}"
  end

  def find_rank(rank)
    case rank
    when 2..10
      rank
    when 'Jack'  then 11
    when 'Queen' then 12
    when 'King'  then 13
    else              14
    end
  end

  def <=>(other)
    find_rank(rank) <=> find_rank(other.rank)
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    create_shuffled_deck
  end

  def draw
    create_shuffled_deck if @cards.empty?
    @cards.shift
  end

  private

  def create_shuffled_deck
    @cards = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end

    @cards.shuffle!
  end
end

class PokerHand
  def initialize(deck)
    @deck = deck
    @hand = []
    5.times { @hand << deck.draw }
  end

  def print
    puts @hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def suits_match?
    suits_match = false
    Deck::SUITS.each do |card_suit|
      suits_match = true if @hand.all? { |card| card.suit == card_suit }
    end
    suits_match
  end

  def royal_straight?
    required_ranks = [10, 'Jack', 'Queen', 'King', 'Ace']

    ranks_match = true
    required_ranks.each do |card_rank|
      ranks_match = false if @hand.none? { |card| card.rank == card_rank }
    end
    ranks_match
  end

  def adjacent_ranks?
    # create all winning straight ranks
    straight_ranks = []
    Deck::RANKS.each_cons(5) { |array| straight_ranks << array }

    # create array of all ranks in hand
    hand_ranks = []
    @hand.each { |card| hand_ranks << card.rank }

    straight_ranks.each do |arr|
      return true if arr.all? { |rank| hand_ranks.include?(rank) }
      # all of the numbers in the subarray must be present in the @hand object
    end
    false
  end

  def identical_ranks?(number)
    Deck::RANKS.each do |card_rank|
      return true if @hand.count { |card| card.rank == card_rank } == number
    end
    false
  end

  def two_identical_ranks?(number)
    first_found = false
    second_found = false

    first_rank = nil
    Deck::RANKS.each do |card_rank|
      if @hand.count { |card| card.rank == card_rank } == number
        first_found = true 
        first_rank = card_rank
        break
      end
    end

    Deck::RANKS.each do |card_rank|
      if @hand.count { |card| card.rank == card_rank } == number && card_rank != first_rank
        second_found = true
        break
      end
    end
    first_found && second_found
  end

  #########

  def royal_flush?
    suits_match? && royal_straight?
  end

  def straight_flush?
    adjacent_ranks? && suits_match?
  end

  def four_of_a_kind?
    identical_ranks?(4)
  end

  def full_house?
    identical_ranks?(2) && identical_ranks?(3)
  end

  def flush?
    suits_match?
  end

  def straight?
    adjacent_ranks?
  end

  def three_of_a_kind?
    identical_ranks?(3)
  end

  def two_pair?
    two_identical_ranks?(2)
  end

  def pair?
    identical_ranks?(2)
  end
end
#

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

hand = nil
counter = 0
loop do
  hand = PokerHand.new(Deck.new)
  # hand.print
  # puts hand.evaluate
  counter += 1
  break if hand.evaluate == "Royal flush"
  puts counter
end
hand.print
puts "Counter: #{counter}"

# Test that we can identify each PokerHand type.
# hand = PokerHand.new([
#   Card.new(10,      'Hearts'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Queen', 'Hearts'),
#   Card.new('King',  'Hearts'),
#   Card.new('Jack',  'Hearts')
# ])
# puts hand.evaluate == 'Royal flush'

# hand = PokerHand.new([
#   Card.new(8,       'Clubs'),
#   Card.new(9,       'Clubs'),
#   Card.new('Queen', 'Clubs'),
#   Card.new(10,      'Clubs'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight flush'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Four of a kind'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Full house'

# hand = PokerHand.new([
#   Card.new(10, 'Hearts'),
#   Card.new('Ace', 'Hearts'),
#   Card.new(2, 'Hearts'),
#   Card.new('King', 'Hearts'),
#   Card.new(3, 'Hearts')
# ])
# puts hand.evaluate == 'Flush'

# hand = PokerHand.new([
#   Card.new(8,      'Clubs'),
#   Card.new(9,      'Diamonds'),
#   Card.new(10,     'Clubs'),
#   Card.new(7,      'Hearts'),
#   Card.new('Jack', 'Clubs')
# ])
# puts hand.evaluate == 'Straight'

# hand = PokerHand.new([
#   Card.new('Queen', 'Clubs'),
#   Card.new('King',  'Diamonds'),
#   Card.new(10,      'Clubs'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(6, 'Diamonds')
# ])
# puts hand.evaluate == 'Three of a kind'

# hand = PokerHand.new([
#   Card.new(9, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(8, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Two pair'

# hand = PokerHand.new([
#   Card.new(2, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(9, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Pair'

# hand = PokerHand.new([
#   Card.new(2,      'Hearts'),
#   Card.new('King', 'Clubs'),
#   Card.new(5,      'Diamonds'),
#   Card.new(9,      'Spades'),
#   Card.new(3,      'Diamonds')
# ])
# puts hand.evaluate== 'High card'

# deck = Deck.new
# drawn = []
# 52.times { drawn << deck.draw }
# p drawn.count { |card| card.rank == 5 } == 4
# p drawn.count { |card| card.suit == 'Hearts' } == 13

# drawn2 = []
# 52.times { drawn2 << deck.draw }
# p drawn != drawn2 # Almost always.


# cards = [Card.new(2, 'Hearts'),
#          Card.new(10, 'Diamonds'),
#          Card.new('Ace', 'Clubs')]
# puts cards
# puts cards.min == Card.new(2, 'Hearts')
# puts cards.max == Card.new('Ace', 'Clubs')

# cards = [Card.new(5, 'Hearts')]
# puts cards.min == Card.new(5, 'Hearts')
# puts cards.max == Card.new(5, 'Hearts')

# cards = [Card.new(4, 'Hearts'),
#          Card.new(4, 'Diamonds'),
#          Card.new(10, 'Clubs')]
# puts cards.min.rank == 4
# puts cards.max == Card.new(10, 'Clubs')

# cards = [Card.new(7, 'Diamonds'),
#          Card.new('Jack', 'Diamonds'),
#          Card.new('Jack', 'Spades')]
# puts cards.min == Card.new(7, 'Diamonds')
# puts cards.max.rank == 'Jack'

# cards = [Card.new(8, 'Diamonds'),
#          Card.new(8, 'Clubs'),
#          Card.new(8, 'Spades')]
# puts cards.min.rank == 8
# puts cards.max.rank == 8deck = Deck.new
