#Update this class so you can use it to determine the lowest ranking and highest ranking cards in an Array of Card objects:

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
