class Player
  DEFAULT_MONEY = 100.0
  attr_accessor :name, :money, :hand

  def initialize(name, hand, money: DEFAULT_MONEY)
    @name = name
    @hand = hand
    @money = money
  end
end
