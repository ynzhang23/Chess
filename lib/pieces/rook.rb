# frozen-string-literal: true

require 'pry-byebug'

# Template and shared method for a rook
class Rook
  attr_reader :symbol, :next_moves, :color
  attr_accessor :current_position

  def initialize(start, symbol, color)
    @symbol = symbol
    @color = color
    @start_position = start
    @current_position = start
    @next_moves = []
  end

  # Update piece location on board
  def update_position(board, new_position, old_position)
    @current_position = new_position
    board.positions[new_position[0]][new_position[1]] = self
    board.positions[old_position[0]][old_position[1]] = '-'
    update_next_moves(board)
    board.print_board
  end

  # Updates @next_moves with current location
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

  def find_openings(board)
    openings = []
    rank = @current_position[0]
    file = @current_position[1]
    # Up
    openings.push('up') if (rank + 1) <= 7 && board.positions[rank + 1][file] == '-'
    # Down
    openings.push('down') if  (rank - 1) >= 0 && board.positions[rank - 1][file] == '-'
    # Left
    openings.push('left') if  (file - 1) >= 0 && board.positions[rank][file - 1] == '-'
    # Right
    openings.push('right') if (file + 1) <= 7 && board.positions[rank][file + 1] == '-'
    openings
  end

  def explore_up(board, rank, file)
    rank += 1
    while  rank < 8 && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      rank += 1
    end
  end

  def explore_down(board, rank, file)
    rank -= 1
    while rank >= 0 && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      rank -= 1
    end
  end

  def explore_left(board, rank, file)
    file -= 1
    while file >= 0 && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      file -= 1
    end
  end

  def explore_right(board, rank, file)
    file += 1
    while file >= 0 && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      file += 1
    end
  end
end

# White rook
class WhiteRook < Rook
  def initialize(rank, file)
    super([rank, file], '♜', 'white')
  end
end

# Black rook
class BlackRook < Rook
  def initialize(rank, file)
    super([rank, file], '♖', 'black')
  end
end
