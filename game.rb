class Game
  BET = 10.0

  def initialize(*players)
    @players = players
    @hands = @players.map { |p| Hand.new(p) }
    @deck = Deck.new
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
    @deck.shuffle

    @hands.each do |hand|
      puts "Игрок #{hand.player.name} получает 2 карты и платит в банк $#{BET}"
      hand.take_cards(@deck, 2)
      hand.player.money -= BET
      @money += BET
    end

    @current_hand = @hands.first
  end

  def show_finance
    players_finance = @players.map { |p| "#{p.name} $#{p.money}" }.join('; ')
    puts "В банке $#{@money}; #{players_finance}"
  end

  def show_status(closed: true)
    puts
    @hands.each do |hand|
      cards_info = if closed && hand.autoplay?
                     "Карты: #{'* ' * hand.cards.count}; Очки: Секрет"
                   else
                     "Карты: #{hand.cards.map(&:name).join(' ')} ; Очки: #{hand.points}"
                   end
      puts "У #{hand.player.name}: #{cards_info}"
    end
  end

  def step
    return stop if should_end?

    puts "\nХод #{@current_hand.player.name}"
    choice = @current_hand.step_choice
    send(choice.to_sym)
    @current_hand = @hands[@hands.index(@current_hand) + 1] || @hands.first
  end

  def skip
    puts "Игрок #{@current_hand.player.name} пропускает ход"
  end

  def add_card
    puts "Игрок #{@current_hand.player.name} берёт 1 карту"
    @current_hand.take_cards(@deck, 1)
  end

  def should_end?
    @hands.all?(&:full?)
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

  def award_winners
    points = @hands.map { |hand| hand.points }
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
    @hands.each { |hand| hand.drop_cards(@deck) }
  end
end
