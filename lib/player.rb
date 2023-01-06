# frozen-string-literal: true

class Player
  def initialize(name = nil, color = nil)
    @name = name
    @color = color
  end

  def update_white_player_name
    puts 'White, please enter your name: '
    @name = gets.chomp
    @color = 'white'
  end

  def update_black_player_name
    puts 'Black, please enter your name: '
    @name = gets.chomp
    @color = 'black'
  end
end
