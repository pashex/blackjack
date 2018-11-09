class Game
  BET = 10.0

  attr_reader :interface

  def initialize(interface, *players)
    @players = players
    @hands = @players.map { |p| Hand.new(interface, p) }
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

    @hands.each do |hand|
      hand.take_cards(@deck, 2)
      interface.show_player_take_cards(hand.player, 2)
      hand.player.money -= BET
      @money += BET
      interface.show_player_pay(hand.player, BET)
    end

    interface.show_finance(@money, @players)
    @current_hand = @hands.first
  end

  def status(closed: true)
    @hands.each do |hand|
      interface.show_hand_info(hand, secret: closed && hand.autoplay?)
    end
  end

  def step
    status
    return stop if should_end?

    interface.show_step(@current_hand.player)
    choice = @current_hand.step_choice
    send(choice.to_sym)
    @current_hand = @hands[@hands.index(@current_hand) + 1] || @hands.first
  end

  def skip
    @current_hand.skip
    interface.show_player_skip(@current_hand.player)
  end

  def add_card
    interface.show_player_take_cards(@current_hand.player, 1)
    @current_hand.take_cards(@deck, 1)
  end

  def stop
    interface.show_end_game
    status(closed: false)
    award_winners
    drop_cards
  end

  def award_winners
    points = @hands.map { |hand| hand.points }
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
    @hands.each { |hand| hand.drop_cards(@deck) }
  end

  def should_end?
    @hands.all?(&:full?)
  end

  def stopped?
    @money.zero?
  end
end
