class ManualHand < Hand
  def initialize(interface)
    @interface = interface
    super()
  end

  def step_choice
    @interface.answer_user_menu(skip: can_skip?, add_card: can_add_card?)
  end
end
