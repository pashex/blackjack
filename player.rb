class Player
  attr_accessor :cards, :points, :name, :money

  def initialize(name, autoplay: true, money: 100.0)
    @name = name
    @autoplay = autoplay
    @money = money
    @points = 0
    @cards = []
  end

  def points
    Card.sum_points(cards)
  end

  def can_add_card?
    cards.count < 3
  end

  def autoplay?
    @autoplay
  end

  def step_choice
    if autoplay?
      return 'skip' if points >= 17
      return 'add_card' if can_add_card?
      'stop'
    else
      puts 'Ваш ход:'
      puts '1. Пропустить ход'
      puts '2. Добавить карту' if can_add_card?
      puts '3. Открыть карты'

      loop do
        choice = gets.chomp.to_i
        return 'skip' if choice == 1
        return 'add_card' if choice == 2 && can_add_card?
        return 'stop' if choice == 3
      end
    end
  end
end
