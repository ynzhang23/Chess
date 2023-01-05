# frozen-string-literal: true

# Template and shared method for a King
class King
  attr_reader :symbol

  def initialize(start_position, symbol)
    @symbol = symbol
    @start_position = start_position
    @current_position = start_position
    @next_move = nil
  end
end

# White King
class WhiteKing < King
  def initialize(rank, file)
    super([rank, file], '♚')
  end
end

# Black King
class BlackKing < King
  def initialize(rank, file)
    super([rank, file], '♔')
  end
end