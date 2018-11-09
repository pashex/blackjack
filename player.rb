class Player
  DEFAULT_MONEY = 100.0
  attr_accessor :name, :money, :autoplay

  def initialize(name, autoplay: true, money: DEFAULT_MONEY)
    @name = name
    @autoplay = autoplay
    @money = money
  end
end
