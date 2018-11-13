require_relative 'interface.rb'
require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'hand.rb'
require_relative 'deck.rb'
require_relative 'game.rb'

puts 'Имя игрока:'
name = gets.strip

user = Player.new(name)
computer = Player.new('Computer', auto: true)

loop do
  game = Game.new(user, computer)
  game.play

  puts 'Если хотите сыграть ещё, нажмите ENTER. Выход - любой символ'
  choice = gets.strip
  break unless choice == ''
end
