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
    @next_moves.push([rank + 1, file]) if valid_move?(board, rank + 1, file)
    # Down
    @next_moves.push([rank - 1, file]) if valid_move?(board, rank - 1, file)
    # Left
    @next_moves.push([rank, file - 1]) if valid_move?(board, rank, file - 1)
    # Right
    @next_moves.push([rank, file + 1]) if valid_move?(board, rank, file + 1)
    # Up Left
    @next_moves.push([rank + 1, file - 1]) if valid_move?(board, rank + 1, file - 1)
    # Up Right
    @next_moves.push([rank + 1, file + 1]) if valid_move?(board, rank + 1, file + 1)
    # Down Left
    @next_moves.push([rank - 1, file - 1]) if valid_move?(board, rank - 1, file - 1)
    # Down Right
    @next_moves.push([rank - 1, file + 1]) if valid_move?(board, rank - 1, file + 1)
  end

  # Test if space is valid to move to
  def valid_move?(board, rank, file)
    return false if rank.negative? || rank > 7 || file.negative? || file > 7
    return true if board.positions[rank][file] == '-'
    return false if board.positions[rank][file].color == @color

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
