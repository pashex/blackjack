require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'game.rb'

puts 'Имя игрока:'
name = gets.chomp

user = Player.new(name, autoplay: false)
computer = Player.new('Computer')

game = Game.new(user, computer)
game.start

loop do
  game.show_status
  game.do_step
  break if game.stopped?
end
