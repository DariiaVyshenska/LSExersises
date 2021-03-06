class Card
  VALUES = {
    'Jack' => 11,
    'Queen' => 12,
    'King' => 13,
    'Ace' => 14
  }

  include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    case rank
    when 2..10 then rank
    else VALUES[rank]
    end
  end

  protected

  def <=>(other)
    value <=> other.value
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  attr_reader :deck

  def initialize
    @deck = []
    deck_reset
  end

  def deck_reset
    new_deck = []
    RANKS.each do |r|
      SUITS.each { |s| new_deck << Card.new(r, s) }
    end
    @deck = new_deck.shuffle
  end

  def draw
    deck_reset if deck.empty?
    @deck.pop
  end
end

class PokerHand
  FIRST_DRAW = 5

  def initialize(deck)
    @hand = []
    first_draw(deck)
  end

  def print
    puts hand
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

  attr_reader :hand

  def first_draw(deck)
    FIRST_DRAW.times do
      @hand << deck.draw
    end
  end

  def royal_flush?
    straight_flush? && hand.max.rank == 'Ace'
  end

  def straight_flush?
    all_same_suit? && five_seq_rank?
  end

  def four_of_a_kind?
    rank_fr == [1, 4]
  end

  def full_house?
    rank_fr == [2, 3]
  end

  def flush?
    all_same_suit?
  end

  def straight?
    five_seq_rank?
  end

  def three_of_a_kind?
    rank_fr == [1, 1, 3]
  end

  def two_pair?
    rank_fr == [1, 2, 2]
  end

  def pair?
    rank_fr == [1, 1, 1, 2]
  end

  def all_same_suit?
    hand.map(&:suit).uniq.size == 1
  end

  def five_seq_rank?
    hand_values = hand.map(&:value)
    min_value, max_value = hand_values.minmax
    (min_value..max_value).to_a == hand_values.sort
  end

  def rank_fr
    hand.map(&:rank).tally.values.sort
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# # Danger danger danger: monkey
# # patching for testing purposes.
# class Array
#   alias_method :draw, :pop
# end
#
# # Test that we can identify each PokerHand type.
# hand = PokerHand.new([
#   Card.new(10,      'Hearts'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Queen', 'Hearts'),
#   Card.new('King',  'Hearts'),
#   Card.new('Jack',  'Hearts')
# ])
# puts hand.evaluate == 'Royal flush'
#
# hand = PokerHand.new([
#   Card.new(8,       'Clubs'),
#   Card.new(9,       'Clubs'),
#   Card.new('Queen', 'Clubs'),
#   Card.new(10,      'Clubs'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight flush'
#
# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Four of a kind'
#
# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Full house'
#
# hand = PokerHand.new([
#   Card.new(10, 'Hearts'),
#   Card.new('Ace', 'Hearts'),
#   Card.new(2, 'Hearts'),
#   Card.new('King', 'Hearts'),
#   Card.new(3, 'Hearts')
# ])
# puts hand.evaluate == 'Flush'
#
# hand = PokerHand.new([
#   Card.new(8,      'Clubs'),
#   Card.new(9,      'Diamonds'),
#   Card.new(10,     'Clubs'),
#   Card.new(7,      'Hearts'),
#   Card.new('Jack', 'Clubs')
# ])
# puts hand.evaluate == 'Straight'
#
# hand = PokerHand.new([
#   Card.new('Queen', 'Clubs'),
#   Card.new('King',  'Diamonds'),
#   Card.new(10,      'Clubs'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight'
#
# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(6, 'Diamonds')
# ])
# puts hand.evaluate == 'Three of a kind'
#
# hand = PokerHand.new([
#   Card.new(9, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(8, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Two pair'
#
# hand = PokerHand.new([
#   Card.new(2, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(9, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Pair'
#
# hand = PokerHand.new([
#   Card.new(2,      'Hearts'),
#   Card.new('King', 'Clubs'),
#   Card.new(5,      'Diamonds'),
#   Card.new(9,      'Spades'),
#   Card.new(3,      'Diamonds')
# ])
# puts hand.evaluate == 'High card'
