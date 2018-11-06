class Game
  attr_reader :players

  def initialize(*players)
    @players = players
    @deck = Card::DECK.map { |c_name| Card.new(c_name) }
    @money = 0.0
  end

  def start
    @deck.shuffle!

    @players.each do |player|
      2.times.each { player.cards << @deck.delete_at(0) }
      player.money -= 10.0
    end

    @money = 20.0

    @current_player = @players.first
  end

  def skip
    @current_player = @players[@players.index(@current_player) + 1] || @players.first
  end

  def add_card
    @current_player.cards << @deck.delete_at(0)
  end

  def stop
    points = @players.map { |player| Card.sum_points(player.cards) }
    max_points = points.max
    @winners = @players.select.with_index { |player, i| points[i] == max_points }
    @winners.each { |player| player.money += @money / 2 }
    @money = 0
  end
end
