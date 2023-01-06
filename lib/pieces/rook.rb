# frozen-string-literal: true

# Template and shared method for a rook
class Rook
  attr_reader :symbol, :next_moves
  attr_accessor :current_position

  def initialize(start_position, symbol)
    @symbol = symbol
    @start_position = start_position
    @current_position = start_position
    @next_moves = []
  end

  def update_next_moves(board)
    openings = find_openings(board)
    rank = @current_position[0]
    file = @current_position[1]
    # provided valid next moves
    openings.each do |direction|
      explore_up(board, rank, file) if direction == 'up'
      explore_down(board, rank, file) if direction == 'down'
      explore_left(board, rank, file) if direction == 'left'
      explore_right(board, rank, file) if direction == 'right'
    end
  end

  def explore_up(board, rank, file)
    rank += 1
    while board.positions[rank][file] == '-' && rank < 8
      @next_moves.push([rank, file])
      rank += 1
    end
  end

  def explore_down(board, rank, file)
    rank -= 1
    while board.positions[rank][file] == '-' && rank >= 0
      @next_moves.push([rank, file])
      rank -= 1
    end
  end

  def explore_left(board, rank, file)
    file -= 1
    while board.positions[rank][file] == '-' && file >= 0
      @next_moves.push([rank, file])
      file -= 1
    end
  end

  def explore_right(board, rank, file)
    file += 1
    while board.positions[rank][file] == '-' && file >= 0
      @next_moves.push([rank, file])
      file += 1
    end
  end

  def find_openings(board)
    openings = []
    rank = @current_position[0]
    file = @current_position[1]
    # Up
    openings.push('up') if board.positions[rank + 1][file] == '-' && (rank + 1) < 7
    # Down
    openings.push('down') if board.positions[rank - 1][file] == '-' && (rank - 1) >= 0
    # Left
    openings.push('left') if board.positions[rank][file - 1] == '-' && (file - 1) >= 0
    # Right
    openings.push('right') if board.positions[rank][file + 1] == '-' && (file + 1) < 7
    openings
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
