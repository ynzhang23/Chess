# frozen-string-literal: true

# Template and shared method for a Queen
class Queen
  attr_reader :symbol, :next_moves, :color
  attr_accessor :current_position

  def initialize(start_position, symbol, color)
    @symbol = symbol
    @color = color
    @start_position = start_position
    @current_position = start_position
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
      explore_up_left(board, rank, file) if direction == 'up_left'
      explore_up_right(board, rank, file) if direction == 'up_right'
      explore_down_left(board, rank, file) if direction == 'down_left'
      explore_down_right(board, rank, file) if direction == 'down_right'
    end
  end

  # Find opening direction to explore further
  def find_openings(board)
    openings = []
    rank = @current_position[0]
    file = @current_position[1]
    openings.push('up') if board.positions[rank + 1][file] == '-' && (rank + 1) <= 7
    openings.push('down') if board.positions[rank - 1][file] == '-' && (rank - 1) >= 0
    openings.push('left') if board.positions[rank][file - 1] == '-' && (file - 1) >= 0
    openings.push('right') if board.positions[rank][file + 1] == '-' && (file + 1) <= 7
    openings.push('up_left') if board.positions[rank + 1][file - 1] == '-' && (rank + 1) <= 7 && (file - 1) >= 0
    openings.push('up_right') if board.positions[rank + 1][file + 1] == '-' && (rank + 1) >= 0 && (file + 1) <= 7
    openings.push('down_left') if board.positions[rank - 1][file - 1] == '-' && (file - 1) >= 0 && (rank - 1) >= 0
    openings.push('down_right') if board.positions[rank - 1][file + 1] == '-' && (file + 1) <= 7 && (rank - 1) >= 0
    openings
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

  # Move diagonally up left until a block and update @next_moves
  def explore_up_left(board, rank, file)
    rank += 1
    file -= 1
    while board.positions[rank][file] == '-' && rank <= 7 && file >= 0
      @next_moves.push([rank, file])
      rank += 1
      file -= 1
    end
  end

  # Move diagonally up right until a block and update @next_moves
  def explore_up_right(board, rank, file)
    rank += 1
    file += 1
    while board.positions[rank][file] == '-' && rank <= 7 && file <= 7
      @next_moves.push([rank, file])
      rank += 1
      file += 1
    end
  end

  # Move diagonally down left until a block and update @next_moves
  def explore_down_left(board, rank, file)
    rank -= 1
    file -= 1
    # Move diagonally down right until a block
    while board.positions[rank][file] == '-' && file >= 0 && rank >= 0
      @next_moves.push([rank, file])
      rank -= 1
      file -= 1
    end
  end

  # Move diagonally down right until a block and update @next_moves
  def explore_down_right(board, rank, file)
    rank -= 1
    file += 1
    while board.positions[rank][file] == '-' && file >= 0 && file <= 7
      @next_moves.push([rank, file])
      rank -= 1
      file += 1
    end
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