class Interface
  def show(string, indent: false)
    puts if indent
    puts string
  end

  def get_value
    gets.strip
  end

  def answer(question)
    show(question, indent: true)
    get_value
  end

  def show_begin_game
    show('Игра начата!', indent: true)
  end

  def show_end_game
    show('Игра окончена. Открываем карты', indent: true)
  end

  def show_results(winners, victory: true)
    show("Результаты игры:", indent: true)
    if victory
      show("Победители: #{winners.map(&:name).join(', ')}")
    else
      show('Ничья!')
    end
  end

  def show_finance(bank_money, players)
    players_finance = players.map { |p| "#{p.name} $#{p.money}" }.join('; ')
    show("В банке $#{bank_money}; #{players_finance}", indent: true)
  end

  def show_hand_info(hand, secret: false)
    cards_info = if secret
                   "Карты: #{'* ' * hand.cards.count}; Очки: Секрет"
                 else
                   "Карты: #{hand.cards.map(&:name).join(' ')} ; Очки: #{hand.points}"
                 end
    show("У #{hand.player.name}: #{cards_info}")
  end

  def show_player_action(player, action)
    show("Игрок #{player.name} #{action}")
  end

  def show_player_not_enough_money(player)
    show_player_action(player, "не имеет достаточно средств для игры. Его баланс - $#{player.money}")
  end

  def show_player_skip(player)
    show_player_action(player, 'пропускает ход')
  end

  def show_player_take_cards(player, count)
    show_player_action(player, "берёт из колоды #{count} карту(ы)")
  end

  def show_player_pay(player, money)
    show_player_action(player, "платит в банк $#{money}. Его остаток - $#{player.money}")
  end

  def show_player_receive(player, money)
    show_player_action(player, "получает из банка $#{money}. Теперь у него $#{player.money}")
  end

  def show_step(player)
    show("Ход игрока #{player.name}", indent: true)
  end

  def answer_user_menu(skip: true, add_card: true, stop: true)
    show("Выш ход:", indent: true)
    show('1. Пропустить ход') if skip
    show('2. Добавить карту') if add_card
    show('3. Открыть карты') if stop

    choice = get_value
    return 'skip' if choice == '1' && skip
    return 'add_card' if choice == '2' && add_card
    return 'stop' if choice == '3' && stop
  end

  def show_invalid_choice
    show('Неверный выбор. Вводите значение согласно предложенному меню', indent: true)
  end
end
