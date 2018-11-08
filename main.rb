require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'game.rb'

puts 'Имя игрока:'
name = gets.chomp

user = Player.new(name, autoplay: false)
computer = Player.new('Computer')

loop do
  game = Game.new(user, computer)
  game.play

  puts 'Если хотите сыграть ещё, нажмите ENTER'
  choice = gets.strip

  break unless choice == ''
end
