class Hand
  attr_reader :cards, :player

  def initialize(player)
    @cards = []
    @player = player
  end

  def points
    base_sum = cards.sum(&:points)
    cards.select(&:ace?).each do
      base_sum -= 10 if base_sum > 21
    end
    base_sum
  end

  def take_cards(deck, count)
    count.times { cards << deck.pick_card }
  end
end
