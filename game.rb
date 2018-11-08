class Game
  BET = 10.0

  def initialize(*players)
    @players = players
    @deck = Card::DECK.map { |c_name| Card.new(c_name) }
    @money = 0.0
  end

  def play
    looser = @players.find { |p| p.money < BET }
    return puts("У игрока #{looser.name} недостаточно денег для игры") if looser

    start
    show_finance
    loop do
      show_status
      step
      break if stopped?
    end
    show_finance
  end

  private

  def start
    puts 'Игра начата!'
    @deck.shuffle!

    @players.each do |player|
      puts "Игрок #{player.name} получает 2 карты и платит в банк $#{BET}"
      2.times { player.cards << pick_card }
      player.money -= BET
      @money += BET
    end

    @current_player = @players.first
  end

  def show_finance
    players_finance = @players.map { |p| "#{p.name} $#{p.money}" }.join('; ')
    puts "В банке $#{@money}; #{players_finance}"
  end

  def show_status(closed: true)
    puts
    @players.each do |player|
      cards_info = if closed && player.autoplay?
                     "Карты: #{'* ' * player.cards.count}; Очки: Секрет"
                   else
                     "Карты: #{player.cards.map(&:name).join(' ')} ; Очки: #{player.points}"
                   end
      puts "У #{player.name}: #{cards_info}"
    end
  end

  def step
    return stop if should_end?

    puts "\nХод #{@current_player.name}"
    choice = @current_player.step_choice
    send(choice.to_sym)
    @current_player = @players[@players.index(@current_player) + 1] || @players.first
  end

  def skip
    puts "Игрок #{@current_player.name} пропускает ход"
  end

  def add_card
    puts "Игрок #{@current_player.name} берёт 1 карту"
    @current_player.cards << pick_card
  end

  def should_end?
    @players.map(&:cards).all? { |cards| cards.count > 2 }
  end

  def stop
    puts "\nИгра окончена. Открываем карты"
    show_status(closed: false)
    award_winners
    drop_cards

    puts "\nРезультаты игры:"
    show_results
  end

  def stopped?
    @money.zero?
  end

  def pick_card
    @deck.delete_at(0)
  end

  def award_winners
    points = @players.map { |player| Card.sum_points(player.cards) }
    max_points = points.select { |p| p <= 21 }.max
    @winners = @players.select.with_index { |_player, i| points[i] == max_points }
    @winners.each { |player| player.money += @money / @winners.count }
    @money = 0
  end

  def show_results
    return if @winners.empty?

    if @winners.count == @players.count
      puts 'Ничья!'
    else
      puts "Победители: #{@winners.map(&:name).join(', ')}"
    end
  end

  def drop_cards
    @players.each do |player|
      @deck += player.cards
      player.cards = []
    end
  end
end
