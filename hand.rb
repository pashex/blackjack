class Hand
  attr_reader :player, :cards

  def initialize(interface, player)
    @interface = interface
    @player = player
    @cards = []
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

  def drop_cards(deck)
    deck.return_cards(cards)
    cards = []
  end

  def full?
    cards.count > 2
  end

  def step_choice
    if autoplay?
      sleep(5)
      autoplay_choice
    else
      loop do
        choice = manual_choice
        return choice if choice
        @interface.show_invalid_choice
      end
    end
  end

  def autoplay?
    player.autoplay
  end

  private

  def can_add_card?
    cards.count < 3
  end

  def autoplay_choice
    return 'skip' if points >= 17
    return 'add_card' if can_add_card?

    'stop'
  end

  def manual_choice
    @interface.answer_user_menu(add_card: can_add_card?)
  end
end
