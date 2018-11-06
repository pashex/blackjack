class Player
  attr_accessor :points, :name, :money

  def initialize(name, money = 100.0)
    @name = name
    @money = money
    @points = 0
    @cards = []
  end
end
