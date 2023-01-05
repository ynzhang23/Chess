# frozen-string-literal: true

# Template and shared method for a rook
class Rook
  attr_reader :symbol

  def initialize(start_position, symbol)
    @symbol = symbol
    @start_position = start_position
    @current_position = start_position
    @next_move = nil
  end
end

# White rook
class WhiteRook < Rook
  def initialize(rank, file)
    super([rank, file], '♜')
  end
end

# Black rook
class BlackRook < Rook
  def initialize(rank, file)
    super([rank, file], '♖')
  end
end
