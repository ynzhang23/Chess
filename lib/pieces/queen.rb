# frozen-string-literal: true

# Template and shared method for a Queen
class Queen
  attr_reader :symbol

  def initialize(start_position, symbol, color)
    @symbol = symbol
    @color = color
    @start_position = start_position
    @current_position = start_position
    @next_move = nil
  end
end

# White Queen
class WhiteQueen < Queen
  def initialize(rank, file)
    super([rank, file], '♛', 'white')
  end
end

# Black Queen
class BlackQueen < Queen
  def initialize(rank, file)
    super([rank, file], '♕', 'white')
  end
end