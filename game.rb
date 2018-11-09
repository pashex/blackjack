class Game
  BET = 10.0

  attr_reader :interface

  def initialize(interface, *players)
    @players = players
    @deck = Deck.new
    @interface = interface
    @money = 0.0
  end

  def play
    looser = @players.find { |p| p.money < BET }
    return interface.show_player_not_enough_money(looser) if looser

    start
    loop do
      step
      break if stopped?
    end
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
    @current_player = @players.first
  end

  def status(closed: true)
    @players.each do |player|
      interface.show_hand_info(player, secret: closed && player.hand.is_a?(AutoHand))
    end
  end

  def step
    status
    return stop if should_end?

    interface.show_step(@current_player)
    choice = @current_player.hand.step_choice
    send(choice.to_sym)
    @current_player = @players[@players.index(@current_player) + 1] || @players.first
  end

  def skip
    @current_player.hand.skip
    interface.show_player_skip(@current_player)
  end

  def add_card
    interface.show_player_take_cards(@current_player, 1)
    @current_player.hand.take_cards(@deck, 1)
  end

  def stop
    interface.show_end_game
    status(closed: false)
    award_winners
    drop_cards
  end

  def award_winners
    points = @players.map { |player| player.hand.points }
    max_points = points.select { |p| p <= 21 }.max
    @winners = @players.select.with_index { |_player, i| points[i] == max_points }
    interface.show_results(@winners, victory: @winners.count < @players.count)

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

  def should_end?
    @players.map(&:hand).all?(&:full?)
  end

  def stopped?
    @money.zero?
  end
end
