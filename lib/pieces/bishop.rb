# frozen-string-literal: true

# Template and shared method for a Bishop
class Bishop
  attr_reader :symbol

  def initialize(start_position, symbol, color)
    @symbol = symbol
    @color = color
    @start_position = start_position
    @current_position = start_position
    @next_move = nil
  end
end

# White Bishop
class WhiteBishop < Bishop
  def initialize(rank, file)
    super([rank, file], '♝', 'white')
  end
end

# Black Bishop 
class BlackBishop < Bishop
  def initialize(rank, file)
    super([rank, file], '♗', 'black')
  end
end