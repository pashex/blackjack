class Deck
  attr_reader :cards

  def initialize(full: true)
    min_value = full ? 2 : 6
    values = [(min_value..10).to_a, %w[В Д К Т]].flatten

    @cards = Card::SUITS.map { |s| values.map { |v| Card.new(s, v) } }.flatten
  end

  def shuffle
    @cards.shuffle!
  end

  def pick_card
    cards.delete_at(0)
  end

  def return_cards(cards)
    @cards += cards
  end
end
