class Hand
  MAX_SKIP_COUNT = 1

  attr_reader :cards

  def initialize
    @cards = []
    @skip_count = 0
  end

  def points
    base_sum = cards.sum(&:points)
    cards.select(&:ace?).each do
      base_sum -= 10 if base_sum > 21
    end
    base_sum
  end

  def skip
    @skip_count += 1
  end

  def take_cards(deck, count)
    count.times { cards << deck.pick_card }
  end

  def drop_cards(deck)
    deck.return_cards(cards)
    @cards = []
    @skip_count = 0
  end

  def full?
    cards.count > 2
  end

  private

  def can_add_card?
    cards.count < 3
  end

  def can_skip?
    @skip_count < MAX_SKIP_COUNT
  end
end
