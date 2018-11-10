require_relative 'interface.rb'
require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'hand.rb'
require_relative 'deck.rb'
require_relative 'game.rb'

interface = Interface.new
name = interface.answer('Имя игрока:')

user = Player.new(name)
computer = Player.new('Computer', auto: true)

loop do
  game = Game.new(interface, user, computer)
  game.play

  choice = interface.answer('Если хотите сыграть ещё, нажмите ENTER. Выход - любой символ')
  break unless choice == ''
end
