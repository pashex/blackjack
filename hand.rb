class Hand
  attr_reader :player, :cards

  def initialize(player)
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
    puts 'Ваш ход:'
    puts '1. Пропустить ход'
    puts '2. Добавить карту' if can_add_card?
    puts '3. Открыть карты'

    choice = gets.chomp.to_i
    return 'skip' if choice == 1
    return 'add_card' if choice == 2 && can_add_card?
    return 'stop' if choice == 3
  end
end
