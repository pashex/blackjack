class Player
  DEFAULT_MONEY = 100.0
  attr_accessor :cards, :name, :money

  def initialize(name, autoplay: true, money: DEFAULT_MONEY)
    @name = name
    @autoplay = autoplay
    @money = money
    @cards = []
  end

  def points
    Card.sum_points(cards)
  end

  def autoplay?
    @autoplay
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
