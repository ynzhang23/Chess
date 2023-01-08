# frozen-string-literal: true

# Template and shared method for a Knight
class Knight
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
    rank = @current_position[0]
    file = @current_position[1]
    # Possible next moves starting from top right move clockwise
    @next_moves.push([rank + 2, file + 1]) if valid_move?(board, rank + 2, file + 1)
    @next_moves.push([rank + 1, file + 2]) if valid_move?(board, rank + 1, file + 2)
    @next_moves.push([rank - 1, file + 2]) if valid_move?(board, rank - 1, file + 2)
    @next_moves.push([rank - 2, file + 1]) if valid_move?(board, rank - 2, file + 1)
    @next_moves.push([rank - 2, file - 1]) if valid_move?(board, rank - 2, file - 1)
    @next_moves.push([rank - 1, file - 2]) if valid_move?(board, rank - 1, file - 2)
    @next_moves.push([rank + 1, file - 2]) if valid_move?(board, rank + 1, file - 2)
    return unless valid_move?(board, rank + 2, file - 1)

    @next_moves.push([rank + 2, file - 1])
  end

  # Test if space is valid to move to
  def valid_move?(board, rank, file)
    return false if rank.negative? || rank > 7 || file.negative? || file > 7
    return true if board.positions[rank][file] == '-'
    return false if board.positions[rank][file].color == @color

    true
  end
end

# White Knight
class WhiteKnight < Knight
  def initialize(rank, file)
    super([rank, file], '♞', 'white')
  end
end

# Black Knight
class BlackKnight < Knight
  def initialize(rank, file)
    super([rank, file], '♘', 'black')
  end
end
