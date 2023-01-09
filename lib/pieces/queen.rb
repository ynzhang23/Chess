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
    @next_moves.clear
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
    openings.push('up') if valid_move?(board, rank + 1, file)
    openings.push('down') if valid_move?(board, rank - 1, file)
    openings.push('left') if valid_move?(board, rank, file - 1)
    openings.push('right') if valid_move?(board, rank, file + 1)
    openings.push('up_left') if valid_move?(board, rank + 1, file - 1)
    openings.push('up_right') if valid_move?(board, rank + 1, file + 1)
    openings.push('down_left') if valid_move?(board, rank - 1, file - 1)
    openings.push('down_right') if valid_move?(board, rank - 1, file + 1)
    openings
  end

  def explore_up(board, rank, file)
    rank += 1
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      rank += 1
    end
  end

  def explore_down(board, rank, file)
    rank -= 1
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      rank -= 1
    end
  end

  def explore_left(board, rank, file)
    file -= 1
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      file -= 1
    end
  end

  def explore_right(board, rank, file)
    file += 1
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      file += 1
    end
  end

  # Move diagonally up left until a block and update @next_moves
  def explore_up_left(board, rank, file)
    rank += 1
    file -= 1
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      rank += 1
      file -= 1
    end
  end

  # Move diagonally up right until a block and update @next_moves
  def explore_up_right(board, rank, file)
    rank += 1
    file += 1
    while valid_move?(board, rank, file)
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
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      rank -= 1
      file -= 1
    end
  end

  # Move diagonally down right until a block and update @next_moves
  def explore_down_right(board, rank, file)
    rank -= 1
    file += 1
    while valid_move?(board, rank, file)
      @next_moves.push([rank, file])
      rank -= 1
      file += 1
    end
  end

  # Test if space is valid to move to
  def valid_move?(board, rank, file)
    return false if rank.negative? || rank > 7 || file.negative? || file > 7
    return true if board.positions[rank][file] == '-'
    return false if board.positions[rank][file].color == @color

    true
  end
end

# White Queen
class WhiteQueen < Queen
  def initialize(rank, file)
    super([rank, file], '♕', 'white')
  end
end

# Black Queen
class BlackQueen < Queen
  def initialize(rank, file)
    super([rank, file], '♛', 'black')
  end
end