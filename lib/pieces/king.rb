# frozen-string-literal: true

# Template and shared method for a King
class King
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
    rank = @current_position[0]
    file = @current_position[1]
    # Up
    if valid_move?(rank + 1, file)
      @next_moves.push([rank + 1, file]) if board.positions[rank + 1][file] == '-'
    end
    # Down
    if valid_move?(rank - 1, file)
      @next_moves.push([rank - 1, file]) if board.positions[rank - 1][file] == '-'
    end
    # Left
    if valid_move?(rank, file - 1)
      @next_moves.push([rank, file - 1]) if board.positions[rank][file - 1] == '-'
    end
    # Right
    if valid_move?(rank, file + 1)
      @next_moves.push([rank, file + 1]) if board.positions[rank][file + 1] == '-'
    end
    # Up Left
    if valid_move?(rank + 1, file - 1)
      @next_moves.push([rank + 1, file - 1]) if board.positions[rank + 1][file - 1] == '-'
    end
    # Up Right
    if valid_move?(rank + 1, file + 1)
      @next_moves.push([rank + 1, file + 1]) if board.positions[rank + 1][file + 1] == '-'
    end
    # Down Left
    if valid_move?(rank - 1, file - 1)
      @next_moves.push([rank - 1, file - 1]) if board.positions[rank - 1][file - 1] == '-'
    end
    # Down Right
    if valid_move?(rank - 1, file + 1)
      @next_moves.push([rank - 1, file + 1]) if board.positions[rank - 1][file + 1] == '-'
    end
  end

  # Test if space is on board
  def valid_move?(rank, file)
    return false if rank < 0 || rank > 7 || file < 0 || file > 7
    true
  end
end

# White King
class WhiteKing < King
  def initialize(rank, file)
    super([rank, file], '♚', 'white')
  end
end

# Black King
class BlackKing < King
  def initialize(rank, file)
    super([rank, file], '♔', 'black')
  end
end
