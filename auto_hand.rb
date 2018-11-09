class AutoHand < Hand
  def step_choice
    return 'skip' if points >= 17 && can_skip?
    return 'add_card' if points < 17 && can_add_card?

    'stop'
  end
end
