class Player
  DEFAULT_MONEY = 100.0
  attr_accessor :name, :money

  def initialize(name, auto: false, money: DEFAULT_MONEY)
    @name = name
    @auto = auto
    @money = money
  end

  def auto?
    @auto
  end
end
