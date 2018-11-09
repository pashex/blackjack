require_relative 'interface.rb'
require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'hand.rb'
require_relative 'auto_hand.rb'
require_relative 'manual_hand.rb'
require_relative 'deck.rb'
require_relative 'game.rb'

interface = Interface.new
name = interface.answer('Имя игрока:')

user_hand = ManualHand.new(interface)
computer_hand = AutoHand.new

user = Player.new(name, user_hand)
computer = Player.new('Computer', computer_hand)

loop do
  game = Game.new(interface, user, computer)
  game.play

  choice = interface.answer('Если хотите сыграть ещё, нажмите ENTER. Выход - любой символ')
  break unless choice == ''
end
