class Game
  attr_reader :players

  def initialize(*players)
    @players = players
    @deck = Card::DECK.map { |c_name| Card.new(c_name) }
    @money = 0.0
  end

  def start
    puts "Игра начата!"
    @deck.shuffle!

    @players.each do |player|
      puts "Игрок #{player.name} получает 2 карты и платит в банк 10"
      2.times.each { player.cards << @deck.delete_at(0) }
      player.money -= 10.0
    end

    @money = 20.0

    @current_player = @players.first
  end

  def show_status(closed: true)
    puts
    puts "В банке #{@money}"
    @players.each do |player|
      puts "Кошелёк #{player.name}: #{player.money}"
      if closed && player.autoplay?
        puts "Карты #{player.name}: #{'*' * player.cards.count}"
      else
        puts "Карты #{player.name}: #{player.cards.map(&:name).join(' ')}"
        puts "Сумма очков карт: #{player.points}"
      end
    end
  end

  def do_step
    puts
    return stop if should_ended?
    puts "Ход #{@current_player.name}"
    choice = @current_player.step_choice
    self.send(choice.to_sym)
    @current_player = @players[@players.index(@current_player) + 1] || @players.first
  end

  def skip
    puts "Игрок #{@current_player.name} пропускает ход"
  end

  def add_card
    puts "Игрок #{@current_player.name} берёт 1 карту"
    @current_player.cards << @deck.delete_at(0)
  end

  def should_ended?
    @players.map(&:cards).all? { |cards| cards.count > 2 }
  end

  def stop
    puts "Игра окончена. Открываем карты"
    show_status(closed: false)

    points = @players.map { |player| Card.sum_points(player.cards) }
    max_points = points.select { |p| p <= 21 }.max
    @winners = @players.select.with_index { |player, i| points[i] == max_points }
    puts
    puts "Результаты игры:"

    if @winners.count == @players.count
      puts "Ничья!"
    else
      puts "Победители: #{@winners.map(&:name).join(', ')}"
    end

    @winners.each do |player|
      player.money += @money / @winners.count
      puts "Счёт игрока #{player.name}: #{player.money}"
    end

    @players.each do |player|
      @deck += player.cards
      player.cards = []
    end
    @money = 0
  end

  def stopped?
    @money.zero?
  end
end
