# frozen-string-literal: true

require 'pry-byebug'

# Template and shared method for a Bishop
class Bishop
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
    # Up
    openings.push('up_left') if valid_move?(rank + 1, file - 1) && board.positions[rank + 1][file - 1] == '-'
    # Down
    openings.push('up_right') if valid_move?(rank + 1, file + 1) && board.positions[rank + 1][file + 1] == '-'
    # Left
    openings.push('down_left') if valid_move?(rank - 1, file - 1) && board.positions[rank - 1][file - 1] == '-'
    # Right
    openings.push('down_right') if valid_move?(rank - 1, file + 1) && board.positions[rank - 1][file + 1] == '-'
    openings
  end

  # Move diagonally up left until a block and update @next_moves
  def explore_up_left(board, rank, file)
    rank += 1
    file -= 1
    while valid_move?(rank, file) && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      rank += 1
      file -= 1
    end
  end

  # Move diagonally up right until a block and update @next_moves
  def explore_up_right(board, rank, file)
    rank += 1
    file += 1
    while valid_move?(rank, file) && board.positions[rank][file] == '-'
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
    while valid_move?(rank, file) && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      rank -= 1
      file -= 1
    end
  end

  # Move diagonally down right until a block and update @next_moves
  def explore_down_right(board, rank, file)
    rank -= 1
    file += 1
    while valid_move?(rank, file) && board.positions[rank][file] == '-'
      @next_moves.push([rank, file])
      rank -= 1
      file += 1
    end
  end

  # Test if space is on board
  def valid_move?(rank, file)
    return false if rank < 0 || rank > 7 || file < 0 || file > 7
    true
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