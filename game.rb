class Game
  BET = 10.0

  attr_reader :interface

  def initialize(interface, *players)
    @players = players
    @players.each { |player| player.hand = Hand.new }
    @deck = Deck.new
    @interface = interface
    @money = 0.0
  end

  def play
    looser = @players.find { |p| p.money < BET }
    return interface.show_player_not_enough_money(looser) if looser

    start
    @players.each do |player|
      break if step(player) == 'stop'
    end
    stop
  end

  private

  def start
    interface.show_begin_game
    @deck.shuffle

    @players.each do |player|
      player.hand.take_cards(@deck, 2)
      interface.show_player_take_cards(player, 2)
      player.money -= BET
      @money += BET
      interface.show_player_pay(player, BET)
    end

    interface.show_finance(@money, @players)
  end

  def status(closed: true)
    @players.each do |player|
      interface.show_hand_info(player, secret: closed && player.auto?)
    end
  end

  def step(player)
    status
    interface.show_step(player)
    player.auto? ? auto_choice(player) : manual_choice(player)
  end

  def skip(player)
    interface.show_player_skip(player)
  end

  def add_card(player)
    interface.show_player_take_cards(player, 1)
    player.hand.take_cards(@deck, 1)
  end

  def stop
    interface.show_end_game
    status(closed: false)
    choose_winners
    award_winners
    drop_cards
  end

  def choose_winners
    points = @players.map { |player| player.hand.points }
    max_points = points.select { |p| p <= 21 }.max
    @winners = @players.select.with_index { |_player, i| points[i] == max_points }
    interface.show_results(@winners, victory: @winners.count < @players.count)
  end

  def award_winners
    receive_money = @money / @winners.count
    @winners.each do |player|
      player.money += receive_money
      interface.show_player_receive(player, receive_money)
    end
    @money = 0

    interface.show_finance(@money, @players)
  end

  def drop_cards
    @players.each { |player| player.hand.drop_cards(@deck) }
  end

  def manual_choice(player)
    loop do
      choice = interface.answer_user_menu
      case choice
      when '1'
        return skip(player)
      when '2'
        return add_card(player)
      when '3'
        return 'stop'
      else
        interface.show_invalid_choice
      end
    end
  end

  def auto_choice(player)
    player.hand.points >= 17 ? skip(player) : add_card(player)
  end
end
