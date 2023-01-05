# frozen-string-literal: true

# Template and shared method for a Pawn
class Pawn
  attr_reader :symbol

  def initialize(start_position, symbol)
    @symbol = symbol
    @start_position = start_position
    @current_position = start_position
    @next_move = nil
  end
end

# White Pawn
class WhitePawn < Pawn
  def initialize(rank, file)
    super([rank, file], '♟︎')
  end
end

# Black Pawn
class BlackPawn < Pawn
  def initialize(rank, file)
    super([rank, file], '♙')
  end
end