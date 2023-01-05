# frozen-string-literal: true

# Template and shared method for a Knight
class Knight
  attr_reader :symbol

  def initialize(start_position, symbol)
    @symbol = symbol
    @start_position = start_position
    @current_position = start_position
    @next_move = nil
  end
end

# White Knight
class WhiteKnight < Knight
  def initialize(rank, file)
    super([rank, file], '♞')
  end
end

# Black Knight
class BlackKnight < Knight
  def initialize(rank, file)
    super([rank, file], '♘')
  end
end