class Interface
  def answer(question)
    show(question, indent: true)
    input_value
  end

  def show_begin_game
    show('Игра начата!', indent: true)
  end

  def show_end_game
    show('Игра окончена. Открываем карты', indent: true)
  end

  def show_results(winners, victory: true)
    show('Результаты игры:', indent: true)
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

  def show_hand_info(player, secret: false)
    cards_info = if secret
                   "Карты: #{'* ' * player.hand.cards.count}; Очки: Секрет"
                 else
                   "Карты: #{player.hand.cards.map(&:name).join(' ')} ; Очки: #{player.hand.points}"
                 end
    show("У #{player.name}: #{cards_info}")
  end

  def show_player_action(player, action)
    show("Игрок #{player.name} #{action}")
  end

  def show_player_not_enough_money(player)
    show_player_action(player, "не имеет средств для игры. Его баланс - $#{player.money}")
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

  def answer_user_menu
    show('Выш ход:', indent: true)
    show('1. Пропустить ход')
    show('2. Добавить карту')
    show('3. Открыть карты')

    input_value
  end

  def show_invalid_choice
    show('Неверный выбор. Вводите значение согласно предложенному меню', indent: true)
  end

  private

  def show(string, indent: false)
    puts if indent
    puts string
  end

  def input_value
    gets.strip
  end
end
