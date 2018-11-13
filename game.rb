class Game
  BET = 10.0

  def initialize(*players)
    @players = players
    @hands = @players.map { |player| Hand.new(player) }
    @deck = Deck.new
    @interface = Interface.new
    @money = 0.0
    @winners = []
  end

  def play
    return if ended?

    looser = @players.find { |p| p.money < BET }
    return @interface.show_player_not_enough_money(looser) if looser

    start
    @hands.each do |hand|
      break if step(hand) == 'stop'
    end
    stop
  end

  def result
    if ended?
      status(closed: false)
      @interface.show_results(@winners, victory: victory?)
    end
  end

  private

  def start
    @interface.show_begin_game
    @deck.shuffle

    @hands.each do |hand|
      hand.take_cards(@deck, 2)
      @interface.show_player_take_cards(hand.player, 2)
      hand.player.money -= BET
      @money += BET
      @interface.show_player_pay(hand.player, BET)
    end

    @interface.show_finance(@money, @players)
  end

  def status(closed: true)
    @hands.each do |hand|
      @interface.show_hand_info(hand.player, hand.cards, hand.points,
                                secret: closed && hand.player.auto?)
    end
  end

  def step(hand)
    status
    @interface.show_step(hand.player)
    hand.player.auto? ? auto_choice(hand) : manual_choice(hand)
  end

  def skip(hand)
    @interface.show_player_skip(hand.player)
  end

  def add_card(hand)
    @interface.show_player_take_cards(hand.player, 1)
    hand.take_cards(@deck, 1)
  end

  def stop
    @interface.show_end_game
    status(closed: false)
    choose_winners
    award_winners
  end

  def choose_winners
    points = @hands.map { |hand| hand.points }
    max_points = points.select { |p| p <= 21 }.max
    @winners = @players.select.with_index { |_player, i| points[i] == max_points }
    @interface.show_results(@winners, victory: victory?)
  end

  def award_winners
    receive_money = @money / @winners.count
    @winners.each do |player|
      player.money += receive_money
      @interface.show_player_receive(player, receive_money)
    end
    @money = 0

    @interface.show_finance(@money, @players)
  end

  def manual_choice(hand)
    loop do
      choice = @interface.answer_user_menu
      case choice
      when '1'
        return skip(hand)
      when '2'
        return add_card(hand)
      when '3'
        return 'stop'
      else
        @interface.show_invalid_choice
      end
    end
  end

  def auto_choice(hand)
    hand.points >= 17 ? skip(hand) : add_card(hand)
  end

  def ended?
    @winners.any?
  end

  def victory?
    @winners.count < @players.count
  end
end
